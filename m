Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756655Ab3EXPft (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 11:35:49 -0400
Received: from b.ns.miles-group.at ([95.130.255.144]:1660 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753710Ab3EXPfs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 11:35:48 -0400
Message-ID: <519F88CB.4020500@nod.at>
Date: Fri, 24 May 2013 17:35:39 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: =?UTF-8?B?QmrDuHJuIE1vcms=?= <bjorn@mork.no>
CC: gregkh@linuxfoundation.org, dcbw@redhat.com, jhovold@gmail.com,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] serial: Add Option GTM681W to qcserial device table.
References: <1369389711-4290-1-git-send-email-richard@nod.at> <87obc0frdu.fsf@nemi.mork.no>
In-Reply-To: <87obc0frdu.fsf@nemi.mork.no>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 24.05.2013 15:18, schrieb Bjørn Mork:
> Richard Weinberger <richard@nod.at> writes:
>
>> The Option GTM681W uses a qualcomm chip and can be
>> served by the qcserial device driver.
>
> Should it also be added to the qmi_wwan driver?

Don't know. But I can happily test it. :)
Can you please explain me how to use the qmi_wwan driver?
I've never used it.

Thanks,
//richard

