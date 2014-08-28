Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751108AbaH1OPu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 10:15:50 -0400
Received: from mail.emea.novell.com ([130.57.118.101]:47343 "EHLO
	mail.emea.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750801AbaH1OPs convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:4:1>);
	Thu, 28 Aug 2014 10:15:48 -0400
Message-Id: <53FF55B1020000780002EC4A@mail.emea.novell.com>
X-Mailer: Novell GroupWise Internet Agent 14.0.1 
Date: Thu, 28 Aug 2014 15:15:45 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: <david.vrabel@citrix.com>
Cc: <xen-devel@lists.xenproject.org>, <boris.ostrovsky@oracle.com>,
        "Mukesh Rathor" <mukesh.rathor@oracle.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [V1 PATCH 0/2] Linux PVH: set EFER bits..
References: <1409178815-2026-1-git-send-email-mukesh.rathor@oracle.com>
 <53FF37D8.8070509@citrix.com>
In-Reply-To: <53FF37D8.8070509@citrix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 28.08.14 at 16:08, <david.vrabel@citrix.com> wrote:
> The Xen change that broke Linux PVH guests must be reverted.  This
> change may also have broken other guests (e.g., Mirage or one of the
> other unikernel OSes).

If PVH wasn't tech preview, I'd agree. But since it is, I don't see a
reason to revert that change.

Jan

