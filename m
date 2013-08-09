Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932465Ab3HIE3a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 00:29:30 -0400
Received: from mo-p05-ob.rzone.de ([81.169.146.181]:17835 "EHLO
	mo-p05-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752730Ab3HIE33 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 00:29:29 -0400
X-RZG-AUTH: :OmsBZ2C7d7IBoB6EHwegNiNxh/xpjMmBYR0YjlTttojRtSoTwvnOIZoM
X-RZG-CLASS-ID: mo05
From: "Stefan Lippers-Hollmann" <s.L-H@gmx.de>
To: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Subject: Re: [ 008/102] ARM: make vectors page inaccessible from userspace
Date: Fri, 9 Aug 2013 06:29:17 +0200
User-Agent: KMail/1.13.7 (Linux/3.10-5.slh.2-aptosid-686; KDE/4.8.4; i686; ; )
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Russell King <rmk+kernel@arm.linux.org.uk>
References: <20130809015010.208118575@linuxfoundation.org> <20130809015012.154316979@linuxfoundation.org>
In-Reply-To: <20130809015012.154316979@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201308090629.21809.s.L-H@gmx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 09 August 2013, Greg Kroah-Hartman wrote:
> 3.10-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Russell King <rmk+kernel@arm.linux.org.uk>
> 
> commit a5463cd3435475386cbbe7b06e01292ac169d36f upstream.
> 
> If kuser helpers are not provided by the kernel, disable user access to
> the vectors page.  With the kuser helpers gone, there is no reason for
> this page to be visible to userspace.
> 
> Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>


If I read Russell King's response in 

	http://www.spinics.net/lists/stable/msg16792.html
	Message-ID: <20130804105241.GG23006@n2100.arm.linux.org.uk>

correctly, this patch might not be wanted for -stable; this only 
affects queue-3.10 at the moment.

Regards
	Stefan Lippers-Hollmann
