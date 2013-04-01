Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758699Ab3DAWVE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 18:21:04 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46096 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755281Ab3DAWVB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 18:21:01 -0400
Message-ID: <515A083B.7050508@zytor.com>
Date: Mon, 01 Apr 2013 15:20:43 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Vivek Goyal <vgoyal@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, WANG Chao <chaowang@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kexec: use Crash kernel for Crash kernel low
References: <20130320163131.GE2273@redhat.com> <1363807329-24975-1-git-send-email-yinghai@kernel.org> <20130325194245.GA7357@redhat.com> <CAE9FiQU6bGSAODX_-Vir6D-LyY-9Sm84rYzq=gNhDZ5whbia_w@mail.gmail.com> <20130326181418.GA6775@redhat.com> <20130401133428.GA13499@redhat.com> <5159D2E9.7080707@zytor.com> <20130401192606.GA17951@redhat.com> <5159F27E.7060300@zytor.com> <CAE9FiQXikU8-FkYYULHx50qP_ME2bRSzCC=8ZH8iDyUr2ug66g@mail.gmail.com> <515A03DB.6040107@zytor.com> <CAE9FiQWNFbFgXafJBvORRax+GNU_uf0KFnqZ5NQit0BeZZx9LA@mail.gmail.com>
In-Reply-To: <CAE9FiQWNFbFgXafJBvORRax+GNU_uf0KFnqZ5NQit0BeZZx9LA@mail.gmail.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/01/2013 03:17 PM, Yinghai Lu wrote:
> 
> And his last suggestion is just as his old second suggestion.
> 
> I just check the code again, it looks it is easy to change it to support:
> 1. crashkernel=XM
> 2. crashkernel_high=XM
> 3. crashkernel_high=XM crashkernel_low=YM
> 

Yes... my objections that you are giving the user the headache of
dealing with this very much remains, but I don't think we have any good
options.  However, the <size>,<options>.... syntax is at least
extensible, which the above syntax is not.

	-hpa


