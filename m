Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756565AbaJ3GNV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 02:13:21 -0400
Received: from 1wt.eu ([62.212.114.60]:40886 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751127AbaJ3GNU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 02:13:20 -0400
Date: Thu, 30 Oct 2014 07:13:06 +0100
From: Willy Tarreau <w@1wt.eu>
To: Mariusz Gorski <marius.gorski@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: panel: Use designated initializers
Message-ID: <20141030061305.GA9427@1wt.eu>
References: <1414621950-3510-1-git-send-email-marius.gorski@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414621950-3510-1-git-send-email-marius.gorski@gmail.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mariusz,

On Wed, Oct 29, 2014 at 11:32:30PM +0100, Mariusz Gorski wrote:
> Fix "warning: missing initializer [-Wmissing-field-initializers]"
> by using designated struct initializers.
> 
> Signed-off-by: Mariusz Gorski <marius.gorski@gmail.com>

Acked-by: Willy Tarreau <w@1wt.eu>

Thanks,
Willy

