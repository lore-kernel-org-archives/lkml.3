Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934736Ab3DPLhY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 07:37:24 -0400
Received: from muin.pair.com ([209.68.1.55]:64731 "EHLO muin.pair.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934393Ab3DPLhX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 07:37:23 -0400
MIME-Version: 1.0
In-Reply-To: <1365564999-24427-1-git-send-email-Yuantian.Tang@freescale.com>
References: <1365564999-24427-1-git-send-email-Yuantian.Tang@freescale.com>
Date: Tue, 16 Apr 2013 06:37:21 -0500
Message-ID: <CAOZdJXW8qKccGKic3R4o1aqJdbfHcBoAp62B4HPFnF=sUAEvuQ@mail.gmail.com>
Subject: Re: [PATCH v2] of/base: release the node correctly in of_parse_phandle_with_args()
From: Timur Tabi <timur@tabi.org>
To: Yuantian.Tang@freescale.com
Cc: Grant Likely <grant.likely@secretlab.ca>,
        devicetree-discuss <devicetree-discuss@lists.ozlabs.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 9, 2013 at 10:36 PM,  <Yuantian.Tang@freescale.com> wrote:
>
> +                       /* Found it! return success */

I'm pretty sure this comment is in the wrong place.
