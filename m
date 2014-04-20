Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755282AbaDTDfQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2014 23:35:16 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:47055 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752049AbaDTDfM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2014 23:35:12 -0400
X-Sasl-enc: vnaF8oc5OetNU2mlJcqE+QAKTIV7WwkDX6NWW6JCzCax 1397964909
Message-ID: <53534051.2020504@fastmail.fm>
Date: Sun, 20 Apr 2014 11:34:41 +0800
From: Michalis Pappas <mpappas@fastmail.fm>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/3] staging: gdm72xx: Minor cleanup
References: <532BF9B0.2080008@fastmail.fm> <20140418225229.GA28077@kroah.com>
In-Reply-To: <20140418225229.GA28077@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following patches perform various cleanups on the gdm72xx driver.

PATCH 1/3 fixes some small coding style issues
PATCH 2/3 removes an already completed item from the TODO list
PATCH 3/3 replaces some jiffies comparisons with wrap-safe functions

After all patches have been applied, the only remaining issue on the
TODO list is to conform to the coding standards. The remaining issues
reported by checkpatch.pl are probably pedantic, so if agreed, that task
can be removed from the list too.

-Michalis
