Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753362Ab3CFMdE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 07:33:04 -0500
Received: from mail-lb0-f171.google.com ([209.85.217.171]:61650 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751452Ab3CFMdB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 07:33:01 -0500
MIME-Version: 1.0
X-Originating-IP: [93.172.171.94]
In-Reply-To: <1362511248.16460.113.camel@x61.thuisdomein>
References: <1362511248.16460.113.camel@x61.thuisdomein>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Wed, 6 Mar 2013 14:32:39 +0200
Message-ID: <CAK=Wgbbyo0ke4a40=drsZOvRr=BdtfZtiXx-oKKKN_MaOKi+jw@mail.gmail.com>
Subject: Re: [PATCH] remoteproc: properly fix missing CONFIG_FW_LOADER configurations
To: Paul Bolle <pebolle@tiscali.nl>
Cc: stable <stable@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Tivy, Robert" <rtivy@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Mar 5, 2013 at 9:20 PM, Paul Bolle <pebolle@tiscali.nl> wrote:
> Fix obvious typo introduced in commit
> e121aefa7d9f10eee5cf26ed47129237a05d940b ("remoteproc: fix missing
> CONFIG_FW_LOADER configurations").

Robert Tivy (cc'ed) already submitted a patch to this (it's part of a
bigger series Robert is now polishing).

Rob, it might indeed be a good idea to add "CC:
stable@vger.kernel.org" to the commit log.

Thanks,
Ohad.
