Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755986AbaDLBB2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 21:01:28 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59122 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755343AbaDLBBW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 21:01:22 -0400
Date: Fri, 11 Apr 2014 18:04:11 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Dominique van den Broeck <domdevlin@free.fr>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fwserial: (unexhaustive) coding style review
Message-ID: <20140412010411.GA29370@kroah.com>
References: <1397259661.3328.5.camel@wisdom>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1397259661.3328.5.camel@wisdom>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 12, 2014 at 01:41:01AM +0200, Dominique van den Broeck wrote:
> From: Dominique van den Broeck <domdevlin@free.fr>
> fwserial: (unexhaustive) coding style review

No need for the From: line here, or the extra subject line.

> 
> linux-next commit 88a8e0969581869c742a9957ddcfe43063dff687 

This isn't needed either.

> 
> Style-only modifications to make checkpatch.pl --file --strict a bit
> happier.
> I fixed only what was trivial, such as parenthesis alignments (one of
> them,
> at fwserial.c:1349, couldn't be easily replaced by something better,
> though).
> However, I did not comment by myself issues regarding spinlocks or
> memory
> barriers.

Odd linewrapping.

> 
> This is my very first patch. Please be indulgent and forgive my eventual
> mistakes. I did that to start contributing to linux kernel, but also
> as task #10 of the Eudyptula Challenge ( http://eudyptula-challenge.org/
> ).

This isn't needed at all, don't put it in the changelog area.


> 
> Signed-off-by: Dominique van den Broeck <domdevlin@free.fr>
> ---
> diff -upr a/drivers/staging/fwserial/dma_fifo.c
> b/drivers/staging/fwserial/dma_fifo.c
> --- a/drivers/staging/fwserial/dma_fifo.c	2014-04-11 20:48:20.813667706
> +0200
> +++ b/drivers/staging/fwserial/dma_fifo.c	2014-04-11 20:47:49.700058306
> +0200

The patch is line-wrapped and can't be applied :(

> @@ -12,10 +12,6 @@
>   * but WITHOUT ANY WARRANTY; without even the implied warranty of
>   * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>   * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write to the Free Software
> Foundation,
> - * Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
>   */

You are fixing a lot of different things here.  Patches need to do only
one thing at a time.  For different coding style cleanups, do it one
patch per "thing", and this will be a few patches at the least.

So, can you fix this all up and resend?

thanks,

greg k-h
