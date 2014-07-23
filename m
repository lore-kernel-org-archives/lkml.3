Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933381AbaGWT4o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 15:56:44 -0400
Received: from mout.kundenserver.de ([212.227.17.10]:56897 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932693AbaGWT4n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 15:56:43 -0400
From: Arnd Bergmann <arnd.bergmann@linaro.org>
Organization: Linaro Limited 
To: Daniel Thompson <daniel.thompson@linaro.org>
Subject: Re: [PATCH CFT] arm: netx: Migrate DEBUG_LL macros to shared directory
Date: Wed, 23 Jul 2014 21:56:38 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-35-generic; KDE/4.3.2; x86_64; ; )
Cc: Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        patches@linaro.org, linaro-kernel@lists.linaro.org,
        linux-arm-kernel@lists.infradead.org
References: <1406108463-11726-1-git-send-email-daniel.thompson@linaro.org>
In-Reply-To: <1406108463-11726-1-git-send-email-daniel.thompson@linaro.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201407232156.38708.arnd.bergmann@linaro.org>
X-Provags-ID: V02:K0:/D9Oo19ig03HiP+4o/wQf6CnTJJEFr4z6McLlmNRNGu
 3jYjfqoZXB3F74Eq90WWbdZIalACq76SvizHt4ET25d6HU8Za8
 7tOcDw+CCNP+Cx/8+AqC+K43UfdwbKme2vGRuBMwv8pO1G0UJa
 sBUgMX35QNAZXU0eW0yV6Pma15tSoc8Oq/Udk0DqrsJcKlIulo
 QTFdF2WhDI3uL10RONyfoCZSaB5OeJJsi1lHv6lShqKOG7g0Sf
 +U+lMEXByp1NzRRcCg0e5pxLhSdZnOa6cyNqJlGri32OLazS31
 0B4i7aIsmLm6+VNyiEvTTBCAzZvLNiP2PJMe5RGl/FU1YJgTZb
 C1g+P0Fjx7T9h574MOMxZAwDgB163Q1Ex7l7+JG1g
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 23 July 2014, Daniel Thompson wrote:
> As part of the migration we introduce DEBUG_UART_PHYS/DEBUG_UART_VIRT
> which default to UART1 but allow a user to configure UART2 or UART3.
> We also introduce symbolic names for the registers and flags.
> 
> Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Arnd Bergmann <arnd.bergmann@linaro.org>
> Cc: linux-arm-kernel@lists.infradead.org

Looks good to me.

Acked-by: Arnd Bergmann <arnd@arndb.de
