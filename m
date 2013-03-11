Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753991Ab3CKTJB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 15:09:01 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:54282 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751247Ab3CKTJA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 15:09:00 -0400
MIME-Version: 1.0
In-Reply-To: <513E2B53.7090304@zytor.com>
References: <513D52BA.3070206@redhat.com>
	<1362977817-23297-1-git-send-email-yinghai@kernel.org>
	<20130311144853.GB8482@redhat.com>
	<20130311150256.GC8482@redhat.com>
	<CAE9FiQW1CHJ-j9aFgdtKEsgyZSTHTS1HzgMSGM8FnV7Ns3kUvw@mail.gmail.com>
	<20130311182655.GB12107@redhat.com>
	<513E2695.3080707@zytor.com>
	<CAE9FiQXLodhSFy4T9pKLMS+axF0jHGL9B0+TL=dYOFrLVudN9g@mail.gmail.com>
	<513E28B8.3000502@zytor.com>
	<CAE9FiQW-gpEMmc6kseb7E+TEg1F9CqEYZBRDiJ3bDY=t6zGRmg@mail.gmail.com>
	<513E2B53.7090304@zytor.com>
Date: Mon, 11 Mar 2013 12:08:59 -0700
X-Google-Sender-Auth: k4ZyczZfKMWjZw7OIi1LymDc9u4
Message-ID: <CAE9FiQVy2JoMqQeXSPdqTf273E4Zk=QikYsV+kbx8FSrhVNKew@mail.gmail.com>
Subject: Re: [PATCH] x86, kdump: Set crashkernel_low automatically
From: Yinghai Lu <yinghai@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>, Simon Horman <horms@verge.net.au>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Vivek Goyal <vgoyal@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>, WANG Chao <chaowang@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 11, 2013 at 12:06 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 03/11/2013 12:06 PM, Yinghai Lu wrote:
>>>
>>> Are you saying 896M is somehow hardcoded into kexec-tools?
>>
>> yes, before kexec-tools 2.0.4
>>
>
> How old is that?

2.0.4 is not released yet. and 2.0.4 would support load v3.9 that
support kernel is loaded high.

Thanks

Yinghai
