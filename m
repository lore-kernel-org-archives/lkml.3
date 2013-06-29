Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753096Ab3F2Tqn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Jun 2013 15:46:43 -0400
Received: from mail-bk0-f45.google.com ([209.85.214.45]:38707 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751151Ab3F2Tqm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Jun 2013 15:46:42 -0400
Message-ID: <51CF399D.8020100@message-id.googlemail.com>
Date: Sat, 29 Jun 2013 21:46:37 +0200
From: Stefan Seyfried <stefan.seyfried@googlemail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: "Winkler, Tomas" <tomas.winkler@intel.com>
Subject: Re: INTEL_MEI_ME=y breaks suspend on 3.10-rc3
References: <51ACD4B2.7070107@message-id.googlemail.com> <51ACD600.2020805@message-id.googlemail.com> <CA+i0qc4eEDjygde4+frqd51JutTDeoJ8mTp-K==gwG_7ghJwcw@mail.gmail.com> <51C0A684.8030405@message-id.googlemail.com> <5B8DA87D05A7694D9FA63FD143655C1B028D67D0@HASMSX106.ger.corp.intel.com> <51C173C2.3030402@message-id.googlemail.com>
In-Reply-To: <51C173C2.3030402@message-id.googlemail.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I hate to say it, but this regression from 3.9 is still present in
3.10-rc7 :-(

Am 19.06.2013 11:02, schrieb Stefan Seyfried:
> The suspend/resume failure is easily reproduced by
> 
> * booting with "init=/bin/bash no_console_suspend"
> * mount /sys
> * echo mem > /sys/power/state
> * resume => lots of messages, finally kernel panic.

Best regards,

	Stefan
-- 
Stefan Seyfried
Linux Consultant & Developer -- GPG Key: 0x731B665B

B1 Systems GmbH
Osterfeldstraße 7 / 85088 Vohburg / http://www.b1-systems.de
GF: Ralph Dehner / Unternehmenssitz: Vohburg / AG: Ingolstadt,HRB 3537
