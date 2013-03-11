Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754300Ab3CKTj6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 15:39:58 -0400
Received: from mail-ia0-f175.google.com ([209.85.210.175]:46555 "EHLO
	mail-ia0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751636Ab3CKTj5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 15:39:57 -0400
MIME-Version: 1.0
In-Reply-To: <20130311193824.GA14738@redhat.com>
References: <1362977817-23297-1-git-send-email-yinghai@kernel.org>
	<20130311144853.GB8482@redhat.com>
	<20130311150256.GC8482@redhat.com>
	<CAE9FiQW1CHJ-j9aFgdtKEsgyZSTHTS1HzgMSGM8FnV7Ns3kUvw@mail.gmail.com>
	<20130311182655.GB12107@redhat.com>
	<513E2695.3080707@zytor.com>
	<CAE9FiQXLodhSFy4T9pKLMS+axF0jHGL9B0+TL=dYOFrLVudN9g@mail.gmail.com>
	<513E28B8.3000502@zytor.com>
	<20130311191031.GD12107@redhat.com>
	<CAE9FiQUxmipKJfUsZdN+J6wGR66VKfLQ8+z41yd3TCJxXTyDRA@mail.gmail.com>
	<20130311193824.GA14738@redhat.com>
Date: Mon, 11 Mar 2013 12:39:56 -0700
X-Google-Sender-Auth: mboYFR-VdW7mV3mUJ7JTr24eUR0
Message-ID: <CAE9FiQUFaA05-Lujn2U01YDCkUo3tady_ZJxhdEDpfR8sLrXMA@mail.gmail.com>
Subject: Re: [PATCH] x86, kdump: Set crashkernel_low automatically
From: Yinghai Lu <yinghai@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>, WANG Chao <chaowang@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 11, 2013 at 12:38 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
>> No need to use crashkernel_high, we can just cashkernel=X@Y instead.
>
> crashkernel=X@Y is little different. It assumes user knows the memory
> map and location "Y" is fixed. There might not be any memory at "Y".

then use crashkernel=4G?
