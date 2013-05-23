Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758885Ab3EWM2u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 08:28:50 -0400
Received: from mail-ve0-f181.google.com ([209.85.128.181]:63944 "EHLO
	mail-ve0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758440Ab3EWM2t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 08:28:49 -0400
MIME-Version: 1.0
In-Reply-To: <1367906651-5058-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1367906651-5058-1-git-send-email-prabhakar.csengg@gmail.com>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Thu, 23 May 2013 17:58:28 +0530
Message-ID: <CA+V-a8sf-SVKiw6wjazV3VRd78efOU9qTO_qtr3RbOtrTifwgw@mail.gmail.com>
Subject: Re: [PATCH] of/base: fix typos
To: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>
Cc: devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rob/Grant,

On Tue, May 7, 2013 at 11:34 AM, Prabhakar Lad
<prabhakar.csengg@gmail.com> wrote:
> From: Lad, Prabhakar <prabhakar.csengg@gmail.com>
>
> the function of_property_read_u8/16/32_array() has a parameter
> out_values, but the description mentioned it as out_value. This
> patch fixes this typo.
>
gentle ping.

Regards,
--Prabhakar Lad
