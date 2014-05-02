Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752004AbaEBMez (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 08:34:55 -0400
Received: from mail-ob0-f173.google.com ([209.85.214.173]:50565 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751721AbaEBMex (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 08:34:53 -0400
MIME-Version: 1.0
In-Reply-To: <CAPUj1OMJ8cE1cNTe8CjgBP2GTCXzi__Yg0+OoomME6=TShgqJg@mail.gmail.com>
References: <CAPUj1OMJ8cE1cNTe8CjgBP2GTCXzi__Yg0+OoomME6=TShgqJg@mail.gmail.com>
Date: Fri, 2 May 2014 18:04:53 +0530
Message-ID: <CAPUj1OML_Rag3gxxBzswS6yaqFciuq2hKrV9BthL2OwU+wNj3A@mail.gmail.com>
Subject: Re: Linux Interrupt Context maps to ARM CPSR.mode = IRQ
From: Mj Embd <mj.embd@gmail.com>
To: kernelnewbies <kernelnewbies@kernelnewbies.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Marc Zyngier <marc.zyngier@arm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding Marc to comment
Marc Please clarify the doubt



On Fri, May 2, 2014 at 5:15 PM, Mj Embd <mj.embd@gmail.com> wrote:
> Hi,
>
> As per a lot of linux documentation some components work in process
> context and some work in interrupt context.
>
> If we try to map these contexts to ARM processor modes then is it
> safely to assume that
> Process Context : CPSR.mode = SVC
> Interrupt Context : CPSR.mode = IRQ
>
> If not how to define interrupt context properly. Confusing at times.
>
> --
> -mj



-- 
-mj
