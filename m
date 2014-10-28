Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753087AbaJ1AIN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 20:08:13 -0400
Received: from mail-vc0-f175.google.com ([209.85.220.175]:37941 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752688AbaJ1AIM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 20:08:12 -0400
MIME-Version: 1.0
X-Originating-IP: [2001:470:8:ee7:614e:6cf5:5221:e045]
In-Reply-To: <1414454639-7491-1-git-send-email-agraf@suse.de>
References: <1414454639-7491-1-git-send-email-agraf@suse.de>
From: Peter Foley <pefoley2@pefoley.com>
Date: Mon, 27 Oct 2014 20:07:51 -0400
Message-ID: <CAOFdcFOChK9Jdw9mQGL7Zdc=89GU4hmuPE=Mn_vvWJFDYEtQBw@mail.gmail.com>
Subject: Re: [PATCH] Documentation: Restrict TSC test code to x86
To: Alexander Graf <agraf@suse.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Jiri Kosina <jkosina@suse.cz>, Randy Dunlap <rdunlap@infradead.org>,
        afaerber@suse.de
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 27, 2014 at 8:03 PM, Alexander Graf <agraf@suse.de> wrote:
> The prctl test code in Documentation/ tries to show how to
> use a call that only makes sense on x86. Restrict it there
> so that other platforms don't try to call asm("rdtsc").
>
> Signed-off-by: Alexander Graf <agraf@suse.de>

Acked-by: Peter Foley <pefoley2@pefoley.com>
