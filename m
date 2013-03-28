Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752893Ab3C1FaN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 01:30:13 -0400
Received: from smtp-out.abv.bg ([194.153.145.70]:40842 "EHLO smtp-out.abv.bg"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750777Ab3C1FaL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 01:30:11 -0400
DomainKey-Signature: a=rsa-sha1; s=smtp-out; d=abv.bg; c=simple; q=dns;
	b=hG+jVf1ZZ/+GJuL3F4TWrlVTEpBrmTX4WkE/a+N3tAuoHx4oV8r6qe6SggBln80hq
	Wh67PN37+wNlItvXDFlJFXax1W9LF0IRH3VXLU5iMmsoY29EfxF+DCdGvh4KgTZf612
	+7vrkSc1L0RN26YTJbSbRHoBXoB4B/TvI+inT4Y=
Date: Thu, 28 Mar 2013 07:30:07 +0200 (EET)
From: =?UTF-8?B?0JjQstCw0LnQu9C+INCU0LjQvNC40YLRgNC+0LI=?= 
	<freemangordon@abv.bg>
To: Tony Lindgren <tony@atomide.com>
Cc: pali.rohar@gmail.com, nm@ti.com, linux@arm.linux.org.uk,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Message-ID: <24838523.73311.1364448607026.JavaMail.apache@mail82.abv.bg>
Subject: Re: [PATCH] arm: omap: RX-51: ARM errata 430973 workaround
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Priority: 3
X-Mailer: AbvMail 1.0
X-Originating-IP: 130.204.50.168
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Tony,

Who do you expect to make that code merge? Do you expect us to mechanically merge RX51 PPA API patch with the existing generic OMAP PPA API code putting #ifdefs all over the place? Not that it is impossible, but the only real piece of HW I have here is n900, so I just can't be sure the code will still work on the other platforms besides RX51, once the code modified. Please, advice on how to proceed.

Regards,
Ivo

 >-------- Оригинално писмо --------
 >От:  Tony Lindgren 
 >Относно: Re: [PATCH] arm: omap: RX-51: ARM errata 430973 workaround
 >До: Pali Rohár 
 >Изпратено на: Сряда, 2013, Март 27 23:12:09 EET
 >
 >
 >* Pali Rohár  [130327 14:09]:
 >> On Wednesday 27 March 2013 21:56:07 Tony Lindgren wrote:
 >> > * Pali Rohár  [130324 07:31]:
 >> > > it is possible to upstream errata 430973 workaround for
 >> > > RX-51?
 >> > 
 >> > I think we should make the SMC handling a generic function for
 >> > ARM.
 >> > 
 >> > AFAIK just the SMC call numbering is different for various
 >> > implementations. So the handler and passing of the parameters
 >> > seems like it should be generic.
 >> > 
 >> 
 >> Not only, look at freemangordon's email: 
 >> https://lkml.org/lkml/2013/3/1/62
 >
 >Seem like you may need some SoC specific wrapper to the
 >generic function to deal with the params. But still seems
 >like we can have an ARM generic smc funtion.
 >
 >Regards,
 >
 >Tony
 >
