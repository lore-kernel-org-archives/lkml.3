Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752727AbaFFKYa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 06:24:30 -0400
Received: from mail-qg0-f41.google.com ([209.85.192.41]:54101 "EHLO
	mail-qg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752305AbaFFKY1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 06:24:27 -0400
MIME-Version: 1.0
In-Reply-To: <20140606095836.65149718001@webmail.sinamail.sina.com.cn>
References: <20140606095836.65149718001@webmail.sinamail.sina.com.cn>
Date: Fri, 6 Jun 2014 05:24:27 -0500
Message-ID: <CAMP44s2uzcB78s=y9r0pyk5m8ezaaNtAYKiRAw6O+_ZTfzeF2A@mail.gmail.com>
Subject: Re: Interactivity regression since v3.11 in mm/vmscan.c
From: Felipe Contreras <felipe.contreras@gmail.com>
To: zhdxzx@sina.com
Cc: Michal Hocko <mhocko@suse.cz>, linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, dhillf <dhillf@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 6, 2014 at 4:58 AM,  <zhdxzx@sina.com> wrote:

> Alternatively can we try wait_iff_congested(zone, BLK_RW_ASYNC, HZ/10) ?

I see the same problem with that code.

-- 
Felipe Contreras
