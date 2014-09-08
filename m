Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754049AbaIHM6r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 08:58:47 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:64128 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753025AbaIHM6p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 08:58:45 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Peter Griffin <peter.griffin@linaro.org>, linux-kernel@vger.kernel.org,
        stern@rowland.harvard.edu, gregkh@linuxfoundation.org,
        srinivas.kandagatla@gmail.com, maxime.coquelin@st.com,
        patrice.chotard@st.com, devicetree@vger.kernel.org,
        linux-usb@vger.kernel.org, lee.jones@linaro.org
Subject: Re: [PATCH v6 0/5]  Add EHCI and OHCI drivers for STi SoC's
Date: Mon, 08 Sep 2014 14:57:52 +0200
Message-ID: <3096462.9jpenVzhmp@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1410177888-26710-1-git-send-email-peter.griffin@linaro.org>
References: <1410177888-26710-1-git-send-email-peter.griffin@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:W8va4GV/h89xT2LMuWZBR/7xvT0tE5KEUIwh24K3M80
 CI7bySA240HfH3sc/raHbCbsLZ6jsGj7MWUk5qSpU8eZbcqZ+0
 g65aNQAb/J9uwr/dtkhlWBCZaFZucc8QcrLLWXsQM67A58px8/
 S/zGnAT14Z2tWxN1TxyW8XviCg/PzFdRbpD8U0gSoEq4myvHlD
 9F3Q4f8dW1Y7sE+qVHUZrQ756qYYY56ReINlk3Zn/p4fF3UbjJ
 0T8fPpJfzxkjZYExBJ2mR+UNzXswn6K56HLg4anVBrNWVupnoI
 Oofz6HYp3haZVVHY+PFahz/R0HEd7CnGTg2VXXJyCSLwnJbKXZ
 V+1jMnupRechUDAHA0WI=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 08 September 2014 13:04:43 Peter Griffin wrote:
> I believe all feedback has been incorporated, and this series has also been rebased on
> 3.17-rc3.
> 
> It was re-worked from v2 onwards to split out the ehci and ohci parts
> into their own drivers / devices like most other ARM platforms based on
> feedback from Arnd Bergmann (see here http://www.spinics.net/lists/linux-usb/msg111124.html. 
> 
> The ehci-platform & ohci-platform have been used as a basis for this in case we
> wish to merge the drivers again in the future.
> 

Looks good to me. Whole series

Reviewed-by: Arnd Bergmann <arnd@arndb.de>
