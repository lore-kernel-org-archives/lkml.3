Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753241AbaKJOtV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 09:49:21 -0500
Received: from smtp103.mer-nm.internl.net ([217.149.192.139]:44365 "EHLO
	smtp103.mer-nm.internl.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752862AbaKJOtU convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 09:49:20 -0500
X-Spam-Flag: NO
X-Spam-Score: -2.9
X-Spam-Languages: en
Message-ID: <5460D067.3020502@topic.nl>
Date: Mon, 10 Nov 2014 15:49:11 +0100
From: Mike Looijmans <mike.looijmans@topic.nl>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Wolfram Sang <wsa@the-dreams.de>
CC: <linux-i2c@vger.kernel.org>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] i2c-davinci: Handle signals gracefully
References: <1389265885-26777-1-git-send-email-mike.looijmans@topic.nl> <1394779348-4084-1-git-send-email-mike.looijmans@topic.nl> <20140324161432.GA7524@katana> <20140521081727.GE2708@katana> <53808851.7060308@topic.nl> <20140601201134.GA3853@katana> <20141108215155.GA1266@katana>
In-Reply-To: <20141108215155.GA1266@katana>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [192.168.80.45]
X-EXCLAIMER-MD-CONFIG: 9833cda7-5b21-4d34-9a38-8d025ddc3664
X-EXCLAIMER-MD-BIFURCATION-INSTANCE: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

﻿On 11/08/2014 10:51 PM, Wolfram Sang wrote:
> On Sun, Jun 01, 2014 at 10:11:34PM +0200, Wolfram Sang wrote:
>>
>>> Feel free to adap my patch or comments and commit. Or wait a few weeks for
>>> when I have a sponsor to split and update the patch.
>>
>> OK, I'll hope you can make it for 3.17. Thanks!
>
> I now picked the part removing the interruptible-call. The part with
> the new exit-path would need to be resend and retested in case anyone
> is still caring.
>

I think that's the right thing to do. There seems to be little interest in the 
rest of the I2C controller, and it's a tough one to test (you'd have to 
trigger an I2C error at exactly the moment that a clock frequency change is 
about to occur...).




Met vriendelijke groet / kind regards,

Mike Looijmans
System Expert


TOPIC Embedded Systems
Eindhovenseweg 32-C, NL-5683 KH Best
Postbus 440, NL-5680 AK Best
Telefoon: (+31) (0) 499 33 69 79
Telefax:  (+31) (0) 499 33 69 70
E-mail: mike.looijmans@topic.nl
Website: www.topic.nl

Please consider the environment before printing this e-mail

Topic zoekt gedreven (embedded) software specialisten!
http://topic.nl/vacatures/topic-zoekt-software-engineers/

