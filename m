Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756169AbaCLR0b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 13:26:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8538 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755738AbaCLR01 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 13:26:27 -0400
Date: Wed, 12 Mar 2014 13:24:58 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Borislav Petkov <bp@alien8.de>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org, hpa@zytor.com,
        mjg59@srcf.ucam.org, greg@kroah.com, jkosina@suse.cz
Subject: Re: [PATCH 10/11] kexec: Support for loading ELF x86_64 images
Message-ID: <20140312172458.GK14981@redhat.com>
References: <1390849071-21989-1-git-send-email-vgoyal@redhat.com>
 <1390849071-21989-11-git-send-email-vgoyal@redhat.com>
 <20140228145832.GF4326@pd.tnic>
 <20140228171142.GI28744@redhat.com>
 <20140307171233.GD5255@pd.tnic>
 <20140307183959.GE5255@pd.tnic>
 <20140310144237.GA4352@redhat.com>
 <20140312161919.GE23890@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140312161919.GE23890@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 12, 2014 at 05:19:19PM +0100, Borislav Petkov wrote:
> On Mon, Mar 10, 2014 at 10:42:37AM -0400, Vivek Goyal wrote:
> > When I posted V1 of patches, Eric Biederman had said that without ELF
> > loader support this patchset should not go in. He said that ELF is
> > very generic and if we are implementing a new system call we should
> > support ELF loader.
> 
> But why, if nobody uses it?

Eric, can you please help answer this one.

Thanks
Vivek
