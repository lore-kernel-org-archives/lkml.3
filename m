Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758259AbaGSIu2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2014 04:50:28 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:48625 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755826AbaGSIuY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2014 04:50:24 -0400
MIME-Version: 1.0
In-Reply-To: <13187.1405627010@warthog.procyon.org.uk>
References: <cover.1405094060.git.d.kasatkin@samsung.com>
	<7afa0a5a9343ddb354478536bd9dc670057fbebe.1405094060.git.d.kasatkin@samsung.com>
	<13187.1405627010@warthog.procyon.org.uk>
Date: Sat, 19 Jul 2014 11:50:22 +0300
Message-ID: <CACE9dm99qMyR+141mEZ7YWsMrtpWv=MxJ9=9deofmuMbxkzTDw@mail.gmail.com>
Subject: Re: [PATCH 2/2] digsig: make crypto builtin if digsig selected as builtin
From: Dmitry Kasatkin <dmitry.kasatkin@gmail.com>
To: David Howells <dhowells@redhat.com>
Cc: Dmitry Kasatkin <d.kasatkin@samsung.com>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        linux-security-module <linux-security-module@vger.kernel.org>,
        linux-crypto <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 17, 2014 at 10:56 PM, David Howells <dhowells@redhat.com> wrote:
> Dmitry Kasatkin <d.kasatkin@samsung.com> wrote:
>
>> When SIGNATURE=y but depends on CRYPTO=m, it selects MPILIB as module
>> producing build break. This patch makes digsig to select crypto for
>> correcting dependency.
>
> I'll apply this one.
>
> David


Thanks,

Dmitry
