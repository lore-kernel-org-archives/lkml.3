Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933179AbaAFX0x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 18:26:53 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:49154 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757463AbaAFX0v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 18:26:51 -0500
Date: Mon, 6 Jan 2014 15:27:17 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Alexander Duyck <alexander.h.duyck@intel.com>
Cc: joe@perches.com, josh@joshtriplett.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] checkpatch: Only flag FSF address, not gnu.org URL
Message-ID: <20140106232717.GA22336@kroah.com>
References: <20140106231534.23578.11475.stgit@ahduyck-cp2.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140106231534.23578.11475.stgit@ahduyck-cp2.jf.intel.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 06, 2014 at 03:16:24PM -0800, Alexander Duyck wrote:
> This change restricts the check for the for the FSF address in the GPL
> copyright statement so that it only flags the address, not the references to
> the gnu.org/licenses URL which appear in numerous drivers.
> 
> So for example this statement will still return an error:
>   You should have received a copy of the GNU General Public License
>   along with this program; if not, write to the Free Software
>   Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
> 
> However, this statement will not return an error after this patch:
>   You should have received a copy of the GNU General Public License
>   along with this program.  If not, see <http://www.gnu.org/licenses/>.

Why is this paragraph needed?  The kernel does come with a copy of the
GPL, so it's not an issue for kernel files, right?

thanks,

greg k-h
