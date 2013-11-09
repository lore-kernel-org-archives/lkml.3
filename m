Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752979Ab3KIMza (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Nov 2013 07:55:30 -0500
Received: from mail-ee0-f45.google.com ([74.125.83.45]:36995 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752186Ab3KIMz3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Nov 2013 07:55:29 -0500
Message-ID: <527E30BD.3030604@linux.com>
Date: Sat, 09 Nov 2013 13:55:25 +0100
From: Levente Kurusa <levex@linux.com>
Reply-To: levex@linux.com
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Baptiste Covolato <b.covolato@gmail.com>, greg@kroah.com
CC: swetland@google.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: android: Add possibility to compile android
 drivers as modules
References: <1384003422-24683-1-git-send-email-b.covolato@gmail.com>
In-Reply-To: <1384003422-24683-1-git-send-email-b.covolato@gmail.com>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013-11-09 14:23 keltezéssel, Baptiste Covolato írta:
> Compilation of Android staging drivers as drivers is now possible.

'drivers as drivers'? :-)

Also, this commit message says nothing about what the patch does.
Something like this would be more appropriate:
Edit Android Kconfig files to allow building the drivers as modules.



-- 
Regards,
Levente Kurusa
