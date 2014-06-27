Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752467AbaF0DZi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 23:25:38 -0400
Received: from mail.active-venture.com ([67.228.131.205]:64809 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751909AbaF0DZh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 23:25:37 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <53ACE42E.5060105@roeck-us.net>
Date: Thu, 26 Jun 2014 20:25:34 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Chen Gang <gang.chen.5i5j@gmail.com>, Lennox Wu <lennox.wu@gmail.com>
CC: David Rientjes <rientjes@google.com>, Liqin Chen <liqin.linux@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] arch/score/include/uapi/asm/ptrace.h: Remove the macros
 which not be used currently
References: <53AC10CB.3000007@gmail.com>	<alpine.DEB.2.02.1406261456150.12443@chino.kir.corp.google.com>	<53ACACB6.6000505@gmail.com> <CAF0htA6=16TDoO0kDDmGipAx17rQZpo7essy5K1sO0=mX--8Lg@mail.gmail.com> <53ACDB42.1070501@gmail.com>
In-Reply-To: <53ACDB42.1070501@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/26/2014 07:47 PM, Chen Gang wrote:
> On 06/27/2014 10:11 AM, Lennox Wu wrote:
>> Acked-by: Lennox Wu <lennox.wu@gmail.com>
>>
>
> OK, thank, and excuse me, I am not quite familiar with the version
> merging of upstream kernel: "who will apply it, next, if it is past all
> reviewers' checking".
>

Normal procedure would be for Lennox (as maintainer) to send a pull request to Linus.

Guenter

