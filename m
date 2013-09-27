Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753298Ab3I0P6u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 11:58:50 -0400
Received: from mail-ie0-f178.google.com ([209.85.223.178]:36936 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751185Ab3I0P6t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 11:58:49 -0400
MIME-Version: 1.0
In-Reply-To: <5245896A.70705@redhat.com>
References: <5245896A.70705@redhat.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Fri, 27 Sep 2013 09:58:28 -0600
Message-ID: <CAErSpo6L-Ud08=JPM7d=RYuPO=UFvq_9hZGbne0iQnCHiFbuHQ@mail.gmail.com>
Subject: Re: kobject_add_internal failed for msi_irqs with -EEXIST
To: Zdenek Kabelac <zkabelac@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux.nics@intel.com,
        "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Veaceslav Falico <vfalico@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[+cc Veaceslav, linux-pci]

On Fri, Sep 27, 2013 at 7:34 AM, Zdenek Kabelac <zkabelac@redhat.com> wrote:
> Hi
>
> With recent build of 3.12-rc2 I'm getting this warning report from kernel:
> (hw Lenovo T61, C2D, 4GB Ram)
> (repost since linux-kernel@ rejected my gmail email....)

This looks related to the MSI/kobject issues Veaceslav is working on.
See http://lkml.kernel.org/r/1379382464-7920-2-git-send-email-vfalico@redhat.com
and related messages.

We don't have a resolution yet.  If you have
CONFIG_DEBUG_KOBJECT_RELEASE=y, you could try turning that off.  I
don't know if it would help, and it would only be a temporary
workaround anyway.

Bjorn
