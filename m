Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753969Ab3AQRZo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 12:25:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51089 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751804Ab3AQRZm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 12:25:42 -0500
Date: Thu, 17 Jan 2013 12:25:37 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
Cc: linux-kernel@vger.kernel.org, ebiederm@xmission.com,
        zohar@linux.vnet.ibm.com, pjones@redhat.com, hpa@zytor.com,
        dhowells@redhat.com, jwboyer@redhat.com,
        linux-security-module <linux-security-module@vger.kernel.org>
Subject: Re: [PATCH 0/3] ELF executable signing and verification
Message-ID: <20130117172537.GA2237@redhat.com>
References: <1358285695-26173-1-git-send-email-vgoyal@redhat.com>
 <CALLzPKZgVUF4_ovyR48BddF33w0pBPvdhxtTQ5bk3M1H1N2LWA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALLzPKZgVUF4_ovyR48BddF33w0pBPvdhxtTQ5bk3M1H1N2LWA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 17, 2013 at 06:22:47PM +0200, Kasatkin, Dmitry wrote:

[..]
> > Currently it is expected to use these patches only for statically linked
> > executables. No dynamic linking. In fact patches specifically disable
> > calling interpreter. This does not prevent against somebody using dlopen()
> > sutff. So don't sign binaries which do that.
> 
> How dynamic linking and interpreter are related together?

Well interpreter will do the dynamic linking automatically? So I blocked
that.

> 
> This is rather policy than enforcement.
> Protection works only for statically linked binaries, because dynamic
> libraries are not verified.

Agreed.

Thanks
Vivek
