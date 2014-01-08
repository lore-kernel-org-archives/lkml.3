Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756510AbaAHMc2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 07:32:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54963 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755679AbaAHMc0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 07:32:26 -0500
Date: Wed, 8 Jan 2014 13:34:29 +0100
From: Alexander Gordeev <agordeev@redhat.com>
To: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        wil6210@qca.qualcomm.com, linux-pci@vger.kernel.org
Subject: Re: [PATCH 7/7] wil6210: Use new interfaces for MSI enablement
Message-ID: <20140108123429.GE20157@dhcp-26-207.brq.redhat.com>
References: <cover.1389103215.git.agordeev@redhat.com>
 <1649789.pNiBbZVqTd@lx-vladimir>
 <20140108115400.GD20157@dhcp-26-207.brq.redhat.com>
 <6233363.QgbOXU7oZU@lx-vladimir>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6233363.QgbOXU7oZU@lx-vladimir>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 08, 2014 at 02:19:01PM +0200, Vladimir Kondratiev wrote:
> Thanks, see it. New code don't distinguish between negative and positive error
> values, same as old code. I'll fix it.

As the patch seems okay for you, I am not quite getting what else needs
to be fixed? :)

> Meanwhile, below my
> 
> Acked-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>

Thanks, Vladimir!

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
