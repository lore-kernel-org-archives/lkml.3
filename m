Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753172AbaCPOcH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2014 10:32:07 -0400
Received: from mail-ee0-f44.google.com ([74.125.83.44]:33247 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751809AbaCPOcG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2014 10:32:06 -0400
From: Andreas Sturmlechner <andreas.sturmlechner@gmail.com>
To: Andres Bertens <abertensu@yahoo.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Linux 3.4.83 update: wireless card (iwlwifi) stop working
Date: Sun, 16 Mar 2014 15:30:03 +0100
Message-ID: <3525637.UfROZvi9l2@tux200s>
Organization: Andreas Sturmlechner
User-Agent: KMail/4.12.3 (Linux/3.4.83-gentoo-r1; KDE/4.12.3; x86_64; ; )
In-Reply-To: <53209D66.8000904@yahoo.com>
References: <53209D66.8000904@yahoo.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>On Wed, Mar 12, 2014 at 14:46:14, Andres Bertens wrote:
> 
> I updated today to 3.4.83 kernel and my wireless card stop working (log 
> says: iwlwifi 0000:03:00.0: Unable to initialize device).
> 

Same here with Intel(R) Centrino(R) Ultimate-N 6300 AGN, REV=0x74

> 
> Reverting patch
>      Johannes Berg <johannes.berg@intel.com>
>         iwlwifi: always copy first 16 bytes of commands
> makes it work again.

Confirmed, thanks for the workaround!
