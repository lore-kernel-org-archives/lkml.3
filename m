Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751954AbaHaScg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2014 14:32:36 -0400
Received: from mail-vc0-f177.google.com ([209.85.220.177]:35051 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751464AbaHaScd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2014 14:32:33 -0400
MIME-Version: 1.0
In-Reply-To: <5401703B.4090801@openwrt.org>
References: <1409350479-19108-1-git-send-email-abrestic@chromium.org>
	<5401703B.4090801@openwrt.org>
Date: Sun, 31 Aug 2014 11:32:32 -0700
X-Google-Sender-Auth: 8-t7nfBXHyYcZOh_On04gKMfJkQ
Message-ID: <CAL1qeaH7q1N8oPpyyhTkwDhwGjn80CcfHZt6jqgFVg9ik=KdAQ@mail.gmail.com>
Subject: Re: [PATCH 00/12] MIPS: GIC device-tree support
From: Andrew Bresticker <abrestic@chromium.org>
To: John Crispin <blogic@openwrt.org>
Cc: Ralf Baechle <ralf@linux-mips.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Jeffrey Deans <jeffrey.deans@imgtec.com>,
        Markos Chandras <markos.chandras@imgtec.com>,
        Paul Burton <paul.burton@imgtec.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>,
        Linux-MIPS <linux-mips@linux-mips.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 29, 2014 at 11:33 PM, John Crispin <blogic@openwrt.org> wrote:
> Hi Andrew,
>
> On 30/08/2014 00:14, Andrew Bresticker wrote:
>> Based on 3.17-rc2 and boot tested on Danube (+ out of tree patches) and
>> Malta.
>
> Lantiq makes a mips soc called danube. is this the same family or is
> this just a name collision between 2 chip vendors ?

They are unrelated.  It's just a name collision.
