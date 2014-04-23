Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932135AbaDWHsr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 03:48:47 -0400
Received: from mail-qc0-f170.google.com ([209.85.216.170]:63998 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753938AbaDWHso (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 03:48:44 -0400
MIME-Version: 1.0
In-Reply-To: <20140422122856.GA1053@distanz.ch>
References: <1397824031-4892-1-git-send-email-lftan@altera.com>
	<1397824031-4892-25-git-send-email-lftan@altera.com>
	<20140422122856.GA1053@distanz.ch>
Date: Wed, 23 Apr 2014 15:48:43 +0800
X-Google-Sender-Auth: AjFGJT-zH0mnJGPGvo0Dk3r8e84
Message-ID: <CAFiDJ5-nMLN1ad1zRwE2m5i=6i++5k9LtkVpzd=dJsQczKToLg@mail.gmail.com>
Subject: Re: [PATCH 28/28] Documentation: Add documentation for Nios2 architecture
From: Ley Foon Tan <lftan@altera.com>
To: Tobias Klauser <tklauser@distanz.ch>
Cc: Linux-Arch <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        cltang@codesourcery.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2014 at 8:28 PM, Tobias Klauser <tklauser@distanz.ch> wrote:

>> +What is Nios II?
>> +================
>> +Nios II is a 32-bit embedded-processor architecture designed specifically for the
>> +Altera family of FPGAs. In order to support Linux system, Nios II needs to configure
>
> Minor nit: 'In order to support Linux, Nios II needs to be configured...'
Noted.

>
>> +with MMU and hardware multiplier enabled.
>
