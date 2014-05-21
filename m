Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752254AbaEUNb4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 09:31:56 -0400
Received: from mail-oa0-f43.google.com ([209.85.219.43]:58844 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751018AbaEUNbz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 09:31:55 -0400
MIME-Version: 1.0
In-Reply-To: <CACna6rzTUnxHJX8MmDAbmj5SsL_VscfdV5oj735zMtLY5k8JCA@mail.gmail.com>
References: <CACna6rzTUnxHJX8MmDAbmj5SsL_VscfdV5oj735zMtLY5k8JCA@mail.gmail.com>
Date: Wed, 21 May 2014 15:31:54 +0200
Message-ID: <CACna6rxb2+xBFRt-g7ttkSB++-WtVEMycC7G=wf1ircKPW12ZQ@mail.gmail.com>
Subject: Re: Bisected 3.9 regression: Corrupted low memory (x86, mm: Move
 reserving low memory later in initialization)
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16 May 2014 07:29, Rafał Miłecki <zajec5@gmail.com> wrote:
> Sorry for the late report, this bug appears on my old notebook I don't
> commonly use. Anyway, I've noticed following problem when using
> 3.15-rc1:
>
> Corrupted low memory at ffff88000000be98 (be98 phys) = b02a000400000000

Ping?
