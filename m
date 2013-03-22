Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161033Ab3CVQpI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 12:45:08 -0400
Received: from void.printf.net ([89.145.121.20]:57282 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933488Ab3CVQpG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 12:45:06 -0400
From: Chris Ball <cjb@laptop.org>
To: James Hogan <james.hogan@imgtec.com>
Cc: <linux-mmc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Seungwon Jeon <tgih.jun@samsung.com>,
        Jaehoon Chung <jh80.chung@samsung.com>
Subject: Re: [PATCH] mmc: dw_mmc: move host->data_offset init earlier
References: <1363085034-9270-1-git-send-email-james.hogan@imgtec.com>
Date: Fri, 22 Mar 2013 12:45:01 -0400
In-Reply-To: <1363085034-9270-1-git-send-email-james.hogan@imgtec.com> (James
	Hogan's message of "Tue, 12 Mar 2013 10:43:54 +0000")
Message-ID: <874ng3o036.fsf@octavius.laptop.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Mar 12 2013, James Hogan wrote:
> host->data_offset is initialised at the end of the probe function
> depending on the VERID register, and is used for PIO operations. Move
> this initialisation earlier, before IRQs or slots are initialised, to be
> sure that PIO won't occur prior to host->data_offset being initialised.
>
> Signed-off-by: James Hogan <james.hogan@imgtec.com>
> Cc: Seungwon Jeon <tgih.jun@samsung.com>
> Cc: Jaehoon Chung <jh80.chung@samsung.com>
> Cc: Chris Ball <cjb@laptop.org>

Thanks, pushed to mmc-next for 3.10.

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
