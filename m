Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757205AbaJIN5Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 09:57:16 -0400
Received: from mail-la0-f54.google.com ([209.85.215.54]:57828 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751608AbaJIN5K convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 09:57:10 -0400
From: Michal Nazarewicz <mina86@mina86.com>
To: Robert Baldyga <r.baldyga@samsung.com>, balbi@ti.com
Cc: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, andrzej.p@samsung.com,
        m.szyprowski@samsung.com, k.opasiak@samsung.com,
        Robert Baldyga <r.baldyga@samsung.com>
Subject: Re: [PATCH v3] usb: gadget: f_fs: add "no_disconnect" mode
In-Reply-To: <1412855241-3509-1-git-send-email-r.baldyga@samsung.com>
Organization: http://mina86.com/
References: <1412855241-3509-1-git-send-email-r.baldyga@samsung.com>
User-Agent: Notmuch/0.17+15~gb65ca8e (http://notmuchmail.org) Emacs/24.4.50.1 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
X-Hashcash: 1:20:141009:r.baldyga@samsung.com::HHHOeF6Eivwppsmh:000000000000000000000000000000000000000024O5
X-Hashcash: 1:20:141009:k.opasiak@samsung.com::XCBh83D5Aw1fI3go:00000000000000000000000000000000000000001cMX
X-Hashcash: 1:20:141009:andrzej.p@samsung.com::eOvBJlxBm4jACcaP:00000000000000000000000000000000000000001yK2
X-Hashcash: 1:20:141009:gregkh@linuxfoundation.org::GHnbg8itSFexiq3J:000000000000000000000000000000000001tIB
X-Hashcash: 1:20:141009:m.szyprowski@samsung.com::X7mgBEK1Wh/BN2E5:000000000000000000000000000000000000035UN
X-Hashcash: 1:20:141009:linux-kernel@vger.kernel.org::sQZAlSiX9AF5inSh:0000000000000000000000000000000003RHQ
X-Hashcash: 1:20:141009:balbi@ti.com::aKImDBNtsPaZJ1hR:00000512b
X-Hashcash: 1:20:141009:r.baldyga@samsung.com::4072AGMaAmMBfLR8:00000000000000000000000000000000000000005Bcz
X-Hashcash: 1:20:141009:linux-usb@vger.kernel.org::nN0g9OGfZ317Ve+F:0000000000000000000000000000000000007NMq
Date: Thu, 09 Oct 2014 15:57:03 +0200
Message-ID: <xa1tiojte47k.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 09 2014, Robert Baldyga <r.baldyga@samsung.com> wrote:
> Since we can compose gadgets from many functions, there is the problem
> related to gadget breakage while FunctionFS daemon being closed. FFS
> function is userspace code so there is no way to know when it will close
> files (it doesn't matter what is the reason of this situation, it can
> be daemon logic, program breakage, process kill or any other). So when
> we have another function in gadget which, for example, sends some amount
> of data, does some software update or implements some real-time functionality,
> we may want to keep the gadget connected despite FFS function is no longer
> functional.
>
> We can't just remove one of functions from gadget since it has been
> enumerated, so the only way to keep entire gadget working is to make
> broken FFS function deactivated but still visible to host. For this
> purpose this patch introduces "no_disconnect" mode. It can be enabled
> by setting mount option "no_disconnect=1", and results with defering
> function disconnect to the moment of reopen ep0 file or filesystem
> unmount. After closing all endpoint files, FunctionFS is set to state
> FFS_DEACTIVATED.
>
> When ffs->state == FFS_DEACTIVATED:
> - function is still bound and visible to host,
> - setup requests are automatically stalled,
> - transfers on other endpoints are refused,
> - epfiles, except ep0, are deleted from the filesystem,
> - opening ep0 causes the function to be closes, and then FunctionFS 
>   is ready for descriptors and string write,
> - unmounting of the FunctionFS instance causes the function to be closed.
>
> Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>

Acked-by: Michal Nazarewicz <mina86@mina86.com>

Even though I have some concerns whether the mode should be enable via
a mount option.  Perhaps it should come from the gadget or the daemon?
I don't have strong feelings though, so I would be fine with the code as
is.

> ---
>
> Changelog:
>
> v3:
> - change option name to more descriptive and less scary,
> - fix cleaning up on unmount (call ffs_data_closed() in ffs_fs_kill_sb(),
>   and ffs_data_clear() in ffs_data_closed() if ffs->opened is negative).
>
> v2: https://lkml.org/lkml/2014/10/7/109
> - delete epfiles, excepting ep0, when FFS is in "zombie" mode,
> - add description of FFS_ZOMBIE state,
> - minor cleanups.
>
> v1: https://lkml.org/lkml/2014/10/6/128
>
>  drivers/usb/gadget/function/f_fs.c | 42 +++++++++++++++++++++++++++++++-------
>  drivers/usb/gadget/function/u_fs.h | 22 ++++++++++++++++++++
>  2 files changed, 57 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/usb/gadget/function/f_fs.c b/drivers/usb/gadget/function/f_fs.c
> index 12dbdaf..f326267 100644
> --- a/drivers/usb/gadget/function/f_fs.c
> +++ b/drivers/usb/gadget/function/f_fs.c
> @@ -606,6 +606,8 @@ static unsigned int ffs_ep0_poll(struct file *file, poll_table *wait)
>  		}
>  	case FFS_CLOSING:
>  		break;
> +	case FFS_DEACTIVATED:
> +		break;
>  	}
>  
>  	mutex_unlock(&ffs->mutex);
> @@ -1152,6 +1154,7 @@ struct ffs_sb_fill_data {
>  	struct ffs_file_perms perms;
>  	umode_t root_mode;
>  	const char *dev_name;
> +	bool no_disconnect;
>  	struct ffs_data *ffs_data;
>  };
>  
> @@ -1222,6 +1225,12 @@ static int ffs_fs_parse_opts(struct ffs_sb_fill_data *data, char *opts)
>  
>  		/* Interpret option */
>  		switch (eq - opts) {
> +		case 13:
> +			if (!memcmp(opts, "no_disconnect", 13))
> +				data->no_disconnect = !!value;
> +			else
> +				goto invalid;
> +			break;
>  		case 5:
>  			if (!memcmp(opts, "rmode", 5))
>  				data->root_mode  = (value & 0555) | S_IFDIR;
> @@ -1286,6 +1295,7 @@ ffs_fs_mount(struct file_system_type *t, int flags,
>  			.gid = GLOBAL_ROOT_GID,
>  		},
>  		.root_mode = S_IFDIR | 0500,
> +		.no_disconnect = false,
>  	};
>  	struct dentry *rv;
>  	int ret;
> @@ -1302,6 +1312,7 @@ ffs_fs_mount(struct file_system_type *t, int flags,
>  	if (unlikely(!ffs))
>  		return ERR_PTR(-ENOMEM);
>  	ffs->file_perms = data.perms;
> +	ffs->no_disconnect = data.no_disconnect;
>  
>  	ffs->dev_name = kstrdup(dev_name, GFP_KERNEL);
>  	if (unlikely(!ffs->dev_name)) {
> @@ -1333,6 +1344,7 @@ ffs_fs_kill_sb(struct super_block *sb)
>  	kill_litter_super(sb);
>  	if (sb->s_fs_info) {
>  		ffs_release_dev(sb->s_fs_info);
> +		ffs_data_closed(sb->s_fs_info);
>  		ffs_data_put(sb->s_fs_info);
>  	}
>  }
> @@ -1389,7 +1401,9 @@ static void ffs_data_opened(struct ffs_data *ffs)
>  	ENTER();
>  
>  	atomic_inc(&ffs->ref);
> -	atomic_inc(&ffs->opened);
> +	if (atomic_add_return(1, &ffs->opened) == 1)
> +		if (ffs->state == FFS_DEACTIVATED)
> +			ffs_data_reset(ffs);
>  }
>  
>  static void ffs_data_put(struct ffs_data *ffs)
> @@ -1411,9 +1425,22 @@ static void ffs_data_closed(struct ffs_data *ffs)
>  	ENTER();
>  
>  	if (atomic_dec_and_test(&ffs->opened)) {
> -		ffs->state = FFS_CLOSING;
> -		ffs_data_reset(ffs);
> +		if (ffs->no_disconnect) {
> +			ffs->state = FFS_DEACTIVATED;
> +			if (ffs->epfiles) {
> +				ffs_epfiles_destroy(ffs->epfiles,
> +						   ffs->eps_count);
> +				ffs->epfiles = NULL;
> +			}
> +			if (ffs->setup_state == FFS_SETUP_PENDING)
> +				__ffs_ep0_stall(ffs);
> +		} else {
> +			ffs->state = FFS_CLOSING;
> +			ffs_data_reset(ffs);
> +		}
>  	}
> +	if (atomic_read(&ffs->opened) < 0)
> +		ffs_data_clear(ffs);
>  
>  	ffs_data_put(ffs);
>  }
> @@ -1588,7 +1615,6 @@ static void ffs_epfiles_destroy(struct ffs_epfile *epfiles, unsigned count)
>  	kfree(epfiles);
>  }
>  
> -
>  static void ffs_func_eps_disable(struct ffs_function *func)
>  {
>  	struct ffs_ep *ep         = func->eps;
> @@ -1601,10 +1627,12 @@ static void ffs_func_eps_disable(struct ffs_function *func)
>  		/* pending requests get nuked */
>  		if (likely(ep->ep))
>  			usb_ep_disable(ep->ep);
> -		epfile->ep = NULL;
> -
>  		++ep;
> -		++epfile;
> +
> +		if (epfile) {
> +			epfile->ep = NULL;
> +			++epfile;
> +		}
>  	} while (--count);
>  	spin_unlock_irqrestore(&func->ffs->eps_lock, flags);
>  }
> diff --git a/drivers/usb/gadget/function/u_fs.h b/drivers/usb/gadget/function/u_fs.h
> index cd128e3..7bc0ca2 100644
> --- a/drivers/usb/gadget/function/u_fs.h
> +++ b/drivers/usb/gadget/function/u_fs.h
> @@ -93,6 +93,26 @@ enum ffs_state {
>  	FFS_ACTIVE,
>  
>  	/*
> +	 * Function is visible to host, but it's not functional. All
> +	 * setup requests are stalled and transfers on another endpoints
> +	 * are refused. All epfiles, except ep0, are deleted so there
> +	 * is no way to perform any operations on them.
> +	 *
> +	 * This state is set after closing all functionfs files, when
> +	 * mount parameter "no_disconnect=1" has been set. Function will
> +	 * remain in deactivated state until filesystem is umounted or
> +	 * ep0 is opened again. In the second case functionfs state will
> +	 * be reset, and it will be ready for descriptors and strings
> +	 * writing.
> +	 *
> +	 * This is useful only when functionfs is composed to gadget
> +	 * with another function which can perform some critical
> +	 * operations, and it's strongly desired to have this operations
> +	 * completed, even after functionfs files closure.
> +	 */
> +	FFS_DEACTIVATED,
> +
> +	/*
>  	 * All endpoints have been closed.  This state is also set if
>  	 * we encounter an unrecoverable error.  The only
>  	 * unrecoverable error is situation when after reading strings
> @@ -251,6 +271,8 @@ struct ffs_data {
>  		kgid_t				gid;
>  	}				file_perms;
>  
> +	bool no_disconnect;
> +
>  	/*
>  	 * The endpoint files, filled by ffs_epfiles_create(),
>  	 * destroyed by ffs_epfiles_destroy().
> -- 
> 1.9.1
>

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michał “mina86” Nazarewicz    (o o)
ooo +--<mpn@google.com>--<xmpp:mina86@jabber.org>--ooO--(_)--Ooo--
