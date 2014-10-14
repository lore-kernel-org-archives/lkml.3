Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932168AbaJNL7z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 07:59:55 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:39534 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755241AbaJNL7x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 07:59:53 -0400
X-AuditID: cbfee690-f79ab6d0000046f7-6d-543d1037257f
From: Heesub Shin <heesub.shin@samsung.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Seth Jennings <sjennings@variantweb.net>
Cc: Nitin Gupta <ngupta@vflare.org>, Dan Streetman <ddstreet@ieee.org>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Sunae Seo <sunae.seo@samsung.com>,
        Heesub Shin <heesub.shin@samsung.com>
Subject: [RFC PATCH 0/9] mm/zbud: support highmem pages
Date: Tue, 14 Oct 2014 20:59:19 +0900
Message-id: <1413287968-13940-1-git-send-email-heesub.shin@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrKLMWRmVeSWpSXmKPExsVy+t8zLV1zAdsQg9/LjCzmrF/DZvHykKbF
	hbbdLBYHZy9hsri8aw6bxb01/1ktNrTMYrf4dPQRm0Xj7ndsDpweTyccZPLY9GkSu8eJGb9Z
	PPq2rGL0uP6tyGPnp82sHp83yQWwR3HZpKTmZJalFunbJXBlTJzTwFLwiq+i70MHewNjG08X
	IyeHhICJxL6O+6wQtpjEhXvr2boYuTiEBJYxSuy9u5UVpmjazH4miMQiRomFzb+hnHYmiYa/
	b5i7GDk42AS0JQ5tCwZpEBGIlNj+8CMLSA2zwDFGiW33noFNEhYwl7g4fRFYPYuAqsThB6kg
	YV4Bd4lp70+xQCyTkzh5bDIrSK+EwCJ2icb1G9lBEiwCAhLfJh9iAemVEJCV2HSAGaJeUuLg
	ihssExgFFzAyrGIUTS1ILihOSi8y0StOzC0uzUvXS87P3cQICe0JOxjvHbA+xCjAwajEw1sQ
	aRMixJpYVlyZe4jRFGjDRGYp0eR8YATllcQbGpsZWZiamBobmVuaKYnzvpb6GSwkkJ5Ykpqd
	mlqQWhRfVJqTWnyIkYmDU6qBUX3plaK7aZ8zGyVKbyc0Ppzx3bX0mPzfJbWalfqdR72OmCvM
	7nHJyD19aodE3AuXMHf94xFHl87RWjWjksU55/nEAJUv7v2HtTedOLNN+xXXGwGhw/+lta8L
	5XVHdHaEpL+1LWKWfM7QlVnNMDMkpa7I/ORamTva1jrt9xge/Vbaf1z9qZSpEktxRqKhFnNR
	cSIAt4aij2gCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprPIsWRmVeSWpSXmKPExsVy+t9jAV1zAdsQg2nNehZz1q9hs3h5SNPi
	QttuFouDs5cwWVzeNYfN4t6a/6wWG1pmsVt8OvqIzaJx9zs2B06PpxMOMnls+jSJ3ePEjN8s
	Hn1bVjF6XP9W5LHz02ZWj8+b5ALYoxoYbTJSE1NSixRS85LzUzLz0m2VvIPjneNNzQwMdQ0t
	LcyVFPISc1NtlVx8AnTdMnOALlNSKEvMKQUKBSQWFyvp22GaEBripmsB0xih6xsSBNdjZIAG
	EtYxZkyc08BS8Iqvou9DB3sDYxtPFyMnh4SAicS0mf1MELaYxIV769m6GLk4hAQWMUosbP7N
	BOG0M0k0/H3D3MXIwcEmoC1xaFswSIOIQKTE9ocfWUBqmAWOMUpsu/eMFSQhLGAucXH6IrB6
	FgFVicMPUkHCvALuEtPen2KBWCYncfLYZNYJjNwLGBlWMYqmFiQXFCel5xrqFSfmFpfmpesl
	5+duYgRHzjOpHYwrGywOMQpwMCrx8EqE24QIsSaWFVfmHmKU4GBWEuFV4LANEeJNSaysSi3K
	jy8qzUktPsRoCrR8IrOUaHI+MKrzSuINjU3MjCyNzIxNzI2NlcR5D7RaBwoJpCeWpGanphak
	FsH0MXFwSjUwrupc9fHG6ZDqF9Z1LBWbb77Yq1Umu2cFzweWT2FrL0t1XOGdWf0g9PDliBnT
	nn/X3lyj123zpFlsvsdmWQGF+O+uF9dpPa9aUXWKcc6CeTMqGVPfWcgtbKx90F95S/3zO7OX
	U/9+bjwuejehrXyh/NW3hoePRZ9b2ZDG9v+BXXbAjLq3jy/tKlViKc5INNRiLipOBABfCpFi
	sgIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

zbud is a memory allocator for storing compressed data pages. It keeps
two data objects of arbitrary size on a single page. This simple design
provides very deterministic behavior on reclamation, which is one of
reasons why zswap selected zbud as a default allocator over zsmalloc.

Unlike zsmalloc, however, zbud does not support highmem. This is
problomatic especially on 32-bit machines having relatively small
lowmem. Compressing anonymous pages from highmem and storing them into
lowmem could eat up lowmem spaces.

This limitation is due to the fact that zbud manages its internal data
structures on zbud_header which is kept in the head of zbud_page. For
example, zbud_pages are tracked by several lists and have some status
information, which are being referenced at any time by the kernel. Thus,
zbud_pages should be allocated on a memory region directly mapped,
lowmem.

After some digging out, I found that internal data structures of zbud
can be kept in the struct page, the same way as zsmalloc does. So, this
series moves out all fields in zbud_header to struct page. Though it
alters quite a lot, it does not add any functional differences except
highmem support. I am afraid that this kind of modification abusing
several fields in struct page would be ok.

Heesub Shin (9):
  mm/zbud: tidy up a bit
  mm/zbud: remove buddied list from zbud_pool
  mm/zbud: remove lru from zbud_header
  mm/zbud: remove first|last_chunks from zbud_header
  mm/zbud: encode zbud handle using struct page
  mm/zbud: remove list_head for buddied list from zbud_header
  mm/zbud: drop zbud_header
  mm/zbud: allow clients to use highmem pages
  mm/zswap: use highmem pages for compressed pool

 mm/zbud.c  | 244 ++++++++++++++++++++++++++++++-------------------------------
 mm/zswap.c |   4 +-
 2 files changed, 121 insertions(+), 127 deletions(-)

-- 
1.9.1

