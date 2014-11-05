Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752091AbaKEV7w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 16:59:52 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:42305 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751329AbaKEV7t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 16:59:49 -0500
Message-ID: <545A9DD2.7050602@codeaurora.org>
Date: Wed, 05 Nov 2014 15:59:46 -0600
From: Timur Tabi <timur@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: Mika Westerberg <mika.westerberg@linux.intel.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Ning Li <ning.li@intel.com>,
        Alan Cox <alan@linux.intel.com>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 0/2] pinctrl: Intel Cherryview/Braswell support
References: <1415012493-134561-1-git-send-email-mika.westerberg@linux.intel.com> <CAOZdJXXAQtmR_Wq194nbiEpg2TYS7_5tXhLtDWckD4xMHGkdZg@mail.gmail.com> <20141104082056.GG1618@lahna.fi.intel.com> <545912D2.5090708@codeaurora.org> <CACxGe6t=nK83pGNDKmZJ28BZJqgNjGZgckrzVrBiFko1AcT0xg@mail.gmail.com>
In-Reply-To: <CACxGe6t=nK83pGNDKmZJ28BZJqgNjGZgckrzVrBiFko1AcT0xg@mail.gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/05/2014 03:46 PM, Grant Likely wrote:
>
> Before even attempting to put pinctrl mappings into your driver, there
> should instead be a conversation at the ACPI spec level about whether
> or not it makes sense and what such a binding should look like.

Fair enough.  For GPIO, using the Linux GPIO driver as a back-end for 
the ASL means that we don't have to duplicate the Linux GPIO driver in 
firmware, and it also allows a high degree of flexibility.  That sounds 
like highly desirable features for any device support, including pin 
control.

I don't really understand ACPI/ASL enough to really have much insight in 
this area, but I've been waiting over six months for someone ... anyone 
... to do someone on this area.  So I'm kinda stuck -- I have a vested 
interested in this area, and yet I'm not in a position to contribute much.

-- 
Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the
Code Aurora Forum, a Linux Foundation Collaborative Project.
