Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936614Ab3DRUeV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 16:34:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36513 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936568Ab3DRUeT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 16:34:19 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <CAErSpo6UrUWZt1zNq=kmkTk4F6g4uAOs8VPKepdfeuKKxb7pXQ@mail.gmail.com>
References: <CAErSpo6UrUWZt1zNq=kmkTk4F6g4uAOs8VPKepdfeuKKxb7pXQ@mail.gmail.com> <20130416182550.27773.89310.stgit@warthog.procyon.org.uk> <20130416182734.27773.47452.stgit@warthog.procyon.org.uk>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: dhowells@redhat.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        alsa-devel@alsa-project.org,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        netfilter-devel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        netdev <netdev@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
        openipmi-developer@lists.sourceforge.net
Subject: Re: [PATCH 26/28] proc: Supply a function to remove a proc entry by PDE [RFC]
Date: Thu, 18 Apr 2013 21:34:02 +0100
Message-ID: <24028.1366317242@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bjorn Helgaas <bhelgaas@google.com> wrote:

> I assume you'll merge this via something other than my tree.

Al's vfs tree, I think.

David
