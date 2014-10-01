Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751551AbaJAMst (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 08:48:49 -0400
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:40070 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751053AbaJAMss (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 08:48:48 -0400
Date: Wed, 1 Oct 2014 13:48:38 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Andrew Pinski <apinski@cavium.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "pinskia@gmail.com" <pinskia@gmail.com>
Subject: Re: [PATCH 09/24] ARM64:ILP32: Use the same syscall names as LP64
Message-ID: <20141001124838.GJ12702@e104818-lin.cambridge.arm.com>
References: <1409779158-30963-1-git-send-email-apinski@cavium.com>
 <1409779158-30963-10-git-send-email-apinski@cavium.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409779158-30963-10-git-send-email-apinski@cavium.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 03, 2014 at 10:19:03PM +0100, Andrew Pinski wrote:
> Define __SYSCALL_NONCOMPAT so we use the 64bit naming scheme for ILP32.

The log doesn't match the actual patch.

> --- a/arch/arm64/include/uapi/asm/unistd.h
> +++ b/arch/arm64/include/uapi/asm/unistd.h
> @@ -13,4 +13,10 @@
>   * You should have received a copy of the GNU General Public License
>   * along with this program.  If not, see <http://www.gnu.org/licenses/>.
>   */
> +
> +/* For ILP32, we want to use the non compat names. */
> +#if defined(__ILP32__)
> +#define __ARCH_WANT_64BIT_SYSCALLS
> +#endif
> +
>  #include <asm-generic/unistd.h>

-- 
Catalin
