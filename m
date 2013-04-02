Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932736Ab3DBPqS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 11:46:18 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:48570 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932084Ab3DBPqR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 11:46:17 -0400
MIME-Version: 1.0
In-Reply-To: <20130402153957.GG29506@redhat.com>
References: <20130401192606.GA17951@redhat.com>
	<5159F27E.7060300@zytor.com>
	<CAE9FiQXikU8-FkYYULHx50qP_ME2bRSzCC=8ZH8iDyUr2ug66g@mail.gmail.com>
	<515A03DB.6040107@zytor.com>
	<CAE9FiQWNFbFgXafJBvORRax+GNU_uf0KFnqZ5NQit0BeZZx9LA@mail.gmail.com>
	<515A083B.7050508@zytor.com>
	<CAE9FiQXwy8nLRQAiZ+P56fokisUXAmTJWA07TZ-gSH61K5FQLA@mail.gmail.com>
	<CAE9FiQW1RzP5A_82qUP7gF_6-G3+Ceay_L1FQf7N=MMbQA4+iw@mail.gmail.com>
	<20130402135001.GC29506@redhat.com>
	<CAE9FiQVWprV4YkMq_Pu95AYk_qGzXWPVBWJVDfa=0RbqL63y4Q@mail.gmail.com>
	<20130402153957.GG29506@redhat.com>
Date: Tue, 2 Apr 2013 08:46:16 -0700
X-Google-Sender-Auth: 9wABV9eehMRF_Df1hyIENhITSLI
Message-ID: <CAE9FiQU99i+fBLnCq72c17XTALdsuUS5jrANAbL=1aMm7=mahw@mail.gmail.com>
Subject: Re: [PATCH] kexec: use Crash kernel for Crash kernel low
From: Yinghai Lu <yinghai@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, WANG Chao <chaowang@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 2, 2013 at 8:39 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Tue, Apr 02, 2013 at 07:45:36AM -0700, Yinghai Lu wrote:
>
> [..]
>> 2. keep thing unified when new kexec-tools is used: always high.
>
> I think this is wrong. What if system does not have more than 4G of
> memory. crashkernel=x,high will fail. So just because we have new version
> of kexec-tools, it does not mean that one can always use crashkernel=x,high.

no, it will not fail.

If the system have less 4G, and memblock will still find the ram for us.

Thanks

Yinghai
