Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754420Ab3J3Nad (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 09:30:33 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:55315 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754105Ab3J3Naa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 09:30:30 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Daniel Walker <dwalker@fifo99.com>
Subject: Re: [PATCH 4/4] ARM: msm: Remove 8x50 support
Date: Wed, 30 Oct 2013 14:30:23 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: David Brown <davidb@codeaurora.org>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, Olof Johansson <olof@lixom.net>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
References: <1382993006-27359-1-git-send-email-davidb@codeaurora.org> <1382993006-27359-5-git-send-email-davidb@codeaurora.org> <20131029211901.GB16284@fifo99.com>
In-Reply-To: <20131029211901.GB16284@fifo99.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201310301430.24115.arnd@arndb.de>
X-Provags-ID: V02:K0:YhO6JzFOv7xi6sUfr4786D/zhIeoMDKm0mBVmw02eoY
 DlqLWuekstYnxq+Y0HbYl45wpcrDyW8Df/z/+IPqQrnTraStWs
 YrkcEZBTFwKExZik5i+pZk/1CMu/FiaXjnqrs1SduJz5jiVIkF
 pPqnMfWsMWVY06J82KnMfcuGFjxgqa3DmPNTDCPZmIEDe+dgoX
 f6q/Oc/S4oedjcf8gqFN7F8S6CAUg9X26IvgHMBTloIn/pbPRL
 VpGNMiz9kR4Y7T0agQWF3HwdqP/I1aQ6QZM0hojV++6CC255Zi
 n/2X5WFKewnbLjrlruGsX2FSmA0YMRv3q/rnSonRnsEtGzsfE+
 /P/lm2SrjopwpmZfA7hU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 29 October 2013, Daniel Walker wrote:
> Isn't this the Nexus one platform ? Same as the last one , why don't you
> just update it to use the device tree? This doesn't seem like it would
> be all that difficult. 

Please don't top-post.

> On Mon, Oct 28, 2013 at 01:43:26PM -0700, David Brown wrote:
> > 
> > This code has not been converted to device tree, and is hindering
> > support for the multi-platform kernel on ARM.  If someone wishes to
> > continue support for this target, patches that provide devicetree and
> > multi-platform support can start by re-adding these files.

    ^ Here is your answer.


While I'd definitely love to see support for the Nexus One upstream,
it is evident that nobody has been working on this for a long time.

	Arnd
