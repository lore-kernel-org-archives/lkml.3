Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756699AbaFRN6w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 09:58:52 -0400
Received: from mail.emea.novell.com ([130.57.118.101]:37131 "EHLO
	mail.emea.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751093AbaFRN6v convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:13:2>);
	Wed, 18 Jun 2014 09:58:51 -0400
Message-Id: <53A1B726020000780001B6CF@mail.emea.novell.com>
X-Mailer: Novell GroupWise Internet Agent 14.0.0 
Date: Wed, 18 Jun 2014 14:58:30 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Matt Fleming" <matt@console-pimps.org>,
        "Daniel Kiper" <daniel.kiper@oracle.com>
Cc: <andrew.cooper3@citrix.com>, <david.vrabel@citrix.com>,
        <ian.campbell@citrix.com>, <stefano.stabellini@eu.citrix.com>,
        <jeremy@goop.org>, <matt.fleming@intel.com>, <x86@kernel.org>,
        <tglx@linutronix.de>, <xen-devel@lists.xenproject.org>,
        <boris.ostrovsky@oracle.com>, <konrad.wilk@oracle.com>,
        <eshelton@pobox.com>, <mingo@redhat.com>, <mjg59@srcf.ucam.org>,
        <linux-efi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <hpa@zytor.com>
Subject: Re: [PATCH v5 2/7] efi: Introduce EFI_NO_DIRECT flag
References: <1402678823-24589-1-git-send-email-daniel.kiper@oracle.com>
 <1402678823-24589-3-git-send-email-daniel.kiper@oracle.com>
 <20140618135229.GH24049@console-pimps.org>
In-Reply-To: <20140618135229.GH24049@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 18.06.14 at 15:52, <matt@console-pimps.org> wrote:
> EFI_PARAVIRT will be usable by architectures other than x86, correct? If
> your intention is for it only ever to be used by x86, then it should
> probably be EFI_ARCH_2.

I would expect ARM, once it gets UEFI support on the Xen side, to
be able to handle most of this identically to x86. Which raises the
question whether most of the new Xen-specific code (in one of the
other patches) wouldn't better live under drivers/xen/.

Jan

