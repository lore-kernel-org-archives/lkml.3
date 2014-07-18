Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762493AbaGROe3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 10:34:29 -0400
Received: from blu004-omc3s26.hotmail.com ([65.55.116.101]:63493 "EHLO
	BLU004-OMC3S26.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762474AbaGROe2 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 10:34:28 -0400
X-TMN: [1xX+lt6vTBy8GdcF9PSA8OS4QXD8ai5N/WbmB2zdm+Y=]
X-Originating-Email: [justin.mattock@hotmail.com]
Message-ID: <BLU174-W51BF77DBFE75E197C07DB095F50@phx.gbl>
From: justin mattock <justin.mattock@hotmail.com>
To: Guruswamy Basavaiah <guru2018@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-x86_64@vger.kernel.org" <linux-x86_64@vger.kernel.org>
Subject: RE: [Question] Why should we check irq_fpu_usable before accessing
 using ASENI instructions.
Date: Fri, 18 Jul 2014 07:34:27 -0700
Importance: Normal
In-Reply-To: <CAHSpA58d1QPoeM6cP3CPHNifMNLRMX+f_+Rk_TNMQ7FzpZRZgQ@mail.gmail.com>
References: <CAHSpA58d1QPoeM6cP3CPHNifMNLRMX+f_+Rk_TNMQ7FzpZRZgQ@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 18 Jul 2014 14:34:27.0530 (UTC) FILETIME=[60D2FAA0:01CFA295]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 
> Date: Fri, 18 Jul 2014 13:57:15 +0530
> Subject: [Question] Why should we check irq_fpu_usable before accessing using ASENI instructions.
> From: guru2018@gmail.com
> To: linux-x86_64@vger.kernel.org
> 
> Hello,
> I am new to assembly language programming.
> In Kernel we check irq_fpu_usable before using any of AESNI related
> instruction.
> 1) why should we check the FPU is available for using AESNI instructions ?
> 2) Will AESNI intructions make use of FPU ?
> 
> I tried searching the answer in internet, no where i found the answer.
> Could please come one answer in this list.
> 
> Guru
> --
> To unsubscribe from this list: send the line "unsubscribe linux-x86_64" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at http://vger.kernel.org/majordomo-info.html



resending due to kernel(s) html bounces..

 

anyways hopefully somebody can see this post and answer your questions!
  		 	   		  