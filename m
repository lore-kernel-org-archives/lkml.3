Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759062AbaJ3Kpi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 06:45:38 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:61928 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758617AbaJ3Kpg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 06:45:36 -0400
X-AuditID: cbfec7f5-b7f956d000005ed7-f9-545216ccc5c4
Message-id: <54521697.1030900@samsung.com>
Date: Thu, 30 Oct 2014 11:44:39 +0100
From: Karol Lewandowski <k.lewandowsk@samsung.com>
Organization: Samsung Poland R&D Center
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Icedove/31.1.2
MIME-version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Kosina <jkosina@suse.cz>, Linux API <linux-api@vger.kernel.org>,
        linux-kernel@vger.kernel.org, John Stultz <john.stultz@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Tejun Heo <tj@kernel.org>,
        Ryan Lortie <desrt@desrt.ca>,
        Simon McVittie <simon.mcvittie@collabora.co.uk>, daniel@zonque.org,
        David Herrmann <dh.herrmann@gmail.com>, Paul Moore <pmoore@redhat.com>,
        "casey.schaufler@intel.com" <casey.schaufler@intel.com>,
        marcel@holtmann.org, tixxdz@opendz.org,
        javier.martinez@collabora.co.uk, alban.crequy@collabora.co.uk
Subject: Re: [PATCH 00/12] Add kdbus implementation
References: <54520A21.20404@samsung.com>
In-reply-to: <54520A21.20404@samsung.com>
X-Forwarded-Message-Id: <54520A21.20404@samsung.com>
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrIIsWRmVeSWpSXmKPExsVy+t/xq7pnxIJCDL4dtbC4svUIk8XfScfY
	LW6sWMBk0fT3FYtF9zUWi3mtR1ksmhevZ7M4+rvAYvecxSwWZ37rWmz+3sFmcXnXHDaLb59+
	MVp8vvaL3aJ9xW1Gi5W/t7NZ/Fp+lNFB0OP3r0mMHn+fX2fxuDGrg9Vj56y77B7rdy9n91i8
	5yWTx6ZVnWwed67tYfPYP3cNu8eKX0fYPd7vu8rmcWYBkPV5k5zH9t3LWQL4orhsUlJzMstS
	i/TtErgy7u+9zlzwmb1i2+vFTA2M29m6GDk5JARMJO5MecEEYYtJXLi3HijOxSEksJRRYnfr
	TxYI5xOjxJ5179hBqngFtCQuPutlBbFZBFQlZj/pBouzCRhJfDu0gRnE5hdQl3i37SnYVFGB
	EInWKy1sEL2CEj8m32MBsUUEjCX6z85iB1nALLCAReLg74NgDcJAiUkn3jCC2EICGhI3/98E
	szkFNCVWr5rFCHP2vzkPgYZyADWrS0yZkgsSZhaQl9i85i3zBEahWUjWzUKomoWkagEj8ypG
	0dTS5ILipPRcI73ixNzi0rx0veT83E2MkGj+uoNx6TGrQ4wCHIxKPLwRxwJChFgTy4orcw8x
	SnAwK4nwnhYIChHiTUmsrEotyo8vKs1JLT7EyMTBKdXAuOFPlVei4ZZ+w4fWfisCnT1n+azP
	X5nglLXQuIy9oTeh0mWVWYp1tyTHzPws9rbZV383LUh+m7jJ+lGuRNDzuHUP9ks82iPyyT5Q
	NUipyuKEdeqzKX6bRKc9kbnGVl15zL7CefMLpfen/wcnPhB9yh8ilnKT9+W7R/31+6MZL7za
	LnPrG0uDEktxRqKhFnNRcSIAkUcXu8QCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ Sorry for breaking thread and resend - gmane rejected my original message
  due to too long list of recipients... ]

On 2014-10-30 00:40, Greg Kroah-Hartman wrote:

> There is a 1815 line documentation file in this series, so we aren't
> trying to not provide this type of information here at all.  But yes,
> more background, about why this can't be done in userspace (zero copy,
> less context switches, proper credential passing, timestamping, availble
> at early-boot, LSM hooks for security models to tie into

While you're at it... I did some work on proof-of-concept LSM patches for
kdbus some time ago, see [1][2].  Currently, these are completely of date.

 [1] https://github.com/lmctl/linux/commits/kdbus-lsm-v4.for-systemd-v212
 [2] https://github.com/lmctl/kdbus/commit/aa0885489d19be92fa41c6f0a71df28763228a40

May I ask if you guys have your own plan for LSM or maybe it would be
worth to resurrect [1]?

Cheers,
-- 
Karol Lewandowski, Samsung R&D Institute Poland



