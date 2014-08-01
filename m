Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754326AbaHAI12 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 04:27:28 -0400
Received: from mail.emea.novell.com ([130.57.118.101]:48959 "EHLO
	mail.emea.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750844AbaHAI1Z convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:4:2>);
	Fri, 1 Aug 2014 04:27:25 -0400
Message-Id: <53DB6B8D02000078000284D3@mail.emea.novell.com>
X-Mailer: Novell GroupWise Internet Agent 14.0.0 
Date: Fri, 01 Aug 2014 09:27:25 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Frediano Ziglio" <frediano.ziglio@citrix.com>
Cc: "David Vrabel" <david.vrabel@citrix.com>,
        "xen-devel" <xen-devel@lists.xenproject.org>,
        "Boris Ostrovsky" <boris.ostrovsky@oracle.com>,
        "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>,
        <linux-api@vger.kernel.org>,
        "linux-kernel" <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH 1/2] xen: Implement ioctl to restrict
 privcmd to a specific domain
References: <E1XCqEY-0005zn-V2@lists.xen.org>
In-Reply-To: <E1XCqEY-0005zn-V2@lists.xen.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 31.07.14 at 15:16, <frediano.ziglio@citrix.com> wrote:
> Add a RESTRICT ioctl to /dev/xen/privcmd, which allows privileged commands
> file descriptor to be restricted to only working with a particular domain.

The "with" here has been quite confusing, and I realized that you
mean the subject domain rather than the actor one only after
having gone through quite some parts of the patch. For a patch
this size, a little more of a description (and the original motivation)
would have helped.

Wrt motivation: Why does this need enforcing in the kernel at all?
Doesn't XSM_DM_PRIV mode deal specifically with what you're
trying to do here? Or else I guess I really need some better
explanation of what this is about.

Jan

