Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756587AbaFQWzF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 18:55:05 -0400
Received: from mail-ve0-f172.google.com ([209.85.128.172]:61182 "EHLO
	mail-ve0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756569AbaFQWzB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 18:55:01 -0400
MIME-Version: 1.0
In-Reply-To: <5398749B.4090209@zytor.com>
References: <CA+5PVA4srNrj2xqMYH40N13rV+jC-PbLdyNpoURomTq48cJNBA@mail.gmail.com>
 <CA+5PVA7gL6T2eXAy6G4hGJzhKZ_8KHd0qauKqzuHAP4oTJ97QA@mail.gmail.com>
 <CALCETrXG=752GrPhP8zKJUciiagCVRO0kenDOqL78eP73Y3ryA@mail.gmail.com> <5398749B.4090209@zytor.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 17 Jun 2014 15:54:40 -0700
Message-ID: <CALCETrXMxn1-qqTkf271+=7F1Aiy7c=rNsnq9cRoB=e1k-Q3UQ@mail.gmail.com>
Subject: Re: vdso_install target broken post-3.15
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Josh Boyer <jwboyer@fedoraproject.org>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just a heads up: gdb can't debug the vdso on 3.16-rc1.  I filed a bug:

https://sourceware.org/bugzilla/show_bug.cgi?id=17064

We may need to extend the fake section header hack to all vdso
versions and stick the ELF notes in there.

hpa, can I depend on an x32 toolchain for the x32 build?

--Andy
