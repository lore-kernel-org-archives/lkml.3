Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758780AbaGPKqc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 06:46:32 -0400
Received: from infosrv.imms.de ([194.95.250.51]:45475 "EHLO infosrv.imms.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754376AbaGPKqa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 06:46:30 -0400
X-Greylist: delayed 1095 seconds by postgrey-1.27 at vger.kernel.org; Wed, 16 Jul 2014 06:46:30 EDT
Message-ID: <53C653BC.5020708@imms.de>
Date: Wed, 16 Jul 2014 12:28:12 +0200
From: Rolf Peukert <rolf.peukert@imms.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Subject: Re: [PATCH RT 0/4] Linux 3.2.60-rt89-rc1
References: <20140714200634.590977709@goodmis.org> <53C4623F.5090901@pavlinux.ru>
In-Reply-To: <53C4623F.5090901@pavlinux.ru>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [172.16.10.26]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15.07.2014 01:05, Pavel Vasilyev wrote:
> 15.07.2014 00:06, Steven Rostedt пишет:
>> Dear RT Folks,
>>
>> This is the RT stable review cycle of patch 3.2.60-rt89-rc1.
> 
> Actually 3.2.61
> 
> kernel/irq/manage.c
> kernel/rtmutex.c
> 
> This files FUZZED :(

Just for the record, the (incremental) patch applies and runs without
problems on an 3.2.60-rt88 (built for ARM).

Regards
Rolf

