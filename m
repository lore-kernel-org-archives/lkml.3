Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756835Ab3EPIjJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 04:39:09 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:50726 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755783Ab3EPIjF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 04:39:05 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Michel Lespinasse <walken@google.com>
Cc: Zhang Rui <rui.zhang@intel.com>, linux-acpi@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: ACPI fan driver: uninitialized variable when CONFIG_PM is not set
Date: Thu, 16 May 2013 10:47:42 +0200
Message-ID: <1874883.vU1DFNWl3r@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.9.0+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CANN689EHkK3xzN1bN5tUar=VLQxEanUEvopDH+0qAYkopHJibw@mail.gmail.com>
References: <CANN689GoQm8dGEN6L1xuuc_aZ_65G3N7tBPbEXHjAfebB7xrLw@mail.gmail.com> <1368666443.2063.22.camel@rzhang1-mobl4> <CANN689EHkK3xzN1bN5tUar=VLQxEanUEvopDH+0qAYkopHJibw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, May 16, 2013 12:56:37 AM Michel Lespinasse wrote:
> On Wed, May 15, 2013 at 6:07 PM, Zhang Rui <rui.zhang@intel.com> wrote:
> > Hi, Michel,
> >
> > thanks for your report.
> > please check if the following patch helps or not.
> > https://patchwork.kernel.org/patch/2574691/
> 
> Yes, this solves the issue.
> 
> Is there a chance that this will make it into 3.10 ?

Yes, there is.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
