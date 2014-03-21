Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759957AbaCUIfL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 04:35:11 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:59660 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751620AbaCUIfI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 04:35:08 -0400
X-Sasl-enc: te7lcuj6ZE3FadT5G9I5tXhR7vYrn1zLWMaemG+yLmdY 1395390904
Message-ID: <532BF9B0.2080008@fastmail.fm>
Date: Fri, 21 Mar 2014 16:34:56 +0800
From: Michalis Pappas <mpappas@fastmail.fm>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20131204 Thunderbird/17.0.11
MIME-Version: 1.0
To: gregkh@linuxfoundation.org
CC: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] staging: gdm72xx: Minor cleanup
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
