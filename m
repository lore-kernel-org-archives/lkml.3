Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753376Ab3EUWrn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 18:47:43 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59427 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751940Ab3EUWrm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 18:47:42 -0400
Date: Tue, 21 May 2013 15:47:41 -0700
From: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Seiji Aguchi <seiji.aguchi@hds.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kexec-list (kexec@lists.infradead.org)" <kexec@lists.infradead.org>,
        "ebiederm@xmission.com" <ebiederm@xmission.com>,
        "cbouatmailru@gmail.com" <cbouatmailru@gmail.com>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "Luck, Tony (tony.luck@intel.com)" <tony.luck@intel.com>,
        "kay@vrfy.org" <kay@vrfy.org>, "vgoyal@redhat.com" <vgoyal@redhat.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Tomoki Sekiyama <tomoki.sekiyama@hds.com>
Subject: Re: [PATCH]Add kmsg_dump() to kexec path
Message-ID: <20130521224741.GA5707@kroah.com>
References: <A5ED84D3BB3A384992CBB9C77DEDA4D41AFEF289@USINDEM103.corp.hds.com>
 <20130521154137.0db53981578ee206b21850f9@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130521154137.0db53981578ee206b21850f9@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 21, 2013 at 03:41:37PM -0700, Andrew Morton wrote:
> Guys, can we please get some review attention to this?

I thought it was reviewed, and rejected, already.  Did you miss those
emails?

thanks,

greg k-h
