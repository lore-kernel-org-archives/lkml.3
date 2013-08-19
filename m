Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751511Ab3HSVjk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 17:39:40 -0400
Received: from mail-oa0-f53.google.com ([209.85.219.53]:38016 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750996Ab3HSVjj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 17:39:39 -0400
MIME-Version: 1.0
In-Reply-To: <20130819210939.GJ14273@oranje.fc.hp.com>
References: <1376942419-5684-1-git-send-email-linn@hp.com>
	<e7fc4e2f-4cda-4eef-8d37-bb87773f58e8@email.android.com>
	<CAE9FiQWRp+AMeTnC3MPSWi4as6qaoFiZEsAfjr3+75YT9XMPcQ@mail.gmail.com>
	<20130819210939.GJ14273@oranje.fc.hp.com>
Date: Mon, 19 Aug 2013 14:39:38 -0700
X-Google-Sender-Auth: FCmi0_Bnlu4h71tK2xqUVxHrGng
Message-ID: <CAE9FiQVXMo5NSD4M47+z4N2fN+5dA1E1JKqQPh9ehzBdhgFARQ@mail.gmail.com>
Subject: Re: [RFC PATCH 0/4] EFI boot stub memory map fix
From: Yinghai Lu <yinghai@kernel.org>
To: Linn Crosetto <linn@hp.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Matt Fleming <matt.fleming@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Pekka Enberg <penberg@kernel.org>, Jacob Shin <jacob.shin@amd.com>,
        linux-efi@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 19, 2013 at 2:09 PM, Linn Crosetto <linn@hp.com> wrote:

> One complication with SETUP_E820_EXT is in
> determining the size needed, since a call to allocate_pool will change the
> memory map.

second try or while loop could handle that.

Yinghai
