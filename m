Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753888AbaDWMQB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 08:16:01 -0400
Received: from moutng.kundenserver.de ([212.227.126.131]:52022 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753704AbaDWMPu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 08:15:50 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: James Hogan <james.hogan@imgtec.com>
Subject: Re: [PATCH 1/3] asm-generic: Add renameat2 syscall
Date: Wed, 23 Apr 2014 14:13:52 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vineet Gupta <vgupta@synopsys.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        linux-arm-kernel@lists.infradead.org, Mark Salter <msalter@redhat.com>,
        Aurelien Jacquiot <a-jacquiot@ti.com>, linux-c6x-dev@linux-c6x.org,
        Richard Kuo <rkuo@codeaurora.org>, linux-hexagon@vger.kernel.org,
        linux-metag@vger.kernel.org, Jonas Bonn <jonas@southpole.se>,
        linux@openrisc.net, Chen Liqin <liqin.linux@gmail.com>,
        Lennox Wu <lennox.wu@gmail.com>, Chris Metcalf <cmetcalf@tilera.com>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>
References: <1398247687-13453-1-git-send-email-james.hogan@imgtec.com> <1398247687-13453-2-git-send-email-james.hogan@imgtec.com>
In-Reply-To: <1398247687-13453-2-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201404231413.53113.arnd@arndb.de>
X-Provags-ID: V02:K0:Ct/RzVCLGbF/W8H5i090IagGKPkUSE6dMsGgyYKBhTL
 ywi05K9A6bXf9t9WgdPwyfXgZHV3e4onc2ZoTKQU6uulCDD3QS
 TJSkW3DK9jhPVUrO0JcjEfmbGmLKmBkIYxm72UUMNhq/BWt+Fz
 g1l0GDuBGDM2a0auThY9VSRTUiS4zRy8ozGvzlioWjRlhQg3zX
 iolZkKe6KcjnZ0yRm7+bDGeqU4ND09lm6Tr0RVzo9vYBMK0SxS
 bLmKLdVHlW7qzLaG+saakLm6YnVELYXqHfWbekhqOEwuTCQAmj
 GdUKTYnsq7XzzFpAX6I0sFyVUZyshuSG2cwdCGV/7XDeboAWnC
 ZN9iwyGnB+IUcZNLCdhw=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 23 April 2014, James Hogan wrote:
> Add the renameat2 syscall to the generic syscall list, which is used by
> the following architectures: arc, arm64, c6x, hexagon, metag, openrisc,
> score, tile, unicore32.
> 
> Signed-off-by: James Hogan <james.hogan@imgtec.com>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: linux-arch@vger.kernel.org
> Cc: Vineet Gupta <vgupta@synopsys.com>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will.deacon@arm.com>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: Mark Salter <msalter@redhat.com>
> Cc: Aurelien Jacquiot <a-jacquiot@ti.com>
> Cc: linux-c6x-dev@linux-c6x.org
> Cc: Richard Kuo <rkuo@codeaurora.org>
> Cc: linux-hexagon@vger.kernel.org
> Cc: linux-metag@vger.kernel.org
> Cc: Jonas Bonn <jonas@southpole.se>
> Cc: linux@lists.openrisc.net
> Cc: Chen Liqin <liqin.linux@gmail.com>
> Cc: Lennox Wu <lennox.wu@gmail.com>
> Cc: Chris Metcalf <cmetcalf@tilera.com>
> Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>

Acked-by: Arnd Bergmann <arnd@arndb.de>
