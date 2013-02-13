Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932517Ab3BMJn4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 04:43:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:11187 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756564Ab3BMJnx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 04:43:53 -0500
Message-ID: <1360748621.10139.0.camel@localhost>
Subject: Re: [ 61/61] drm/nouveau: add lockdep annotations
From: Ben Skeggs <bskeggs@redhat.com>
Reply-To: bskeggs@redhat.com
To: Arend van Spriel <arend@broadcom.com>
Cc: Peter Hurley <peter@hurleysoftware.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        Daniel J Blueman <daniel@quora.org>,
        Marcin Slusarz <marcin.slusarz@gmail.com>
Date: Wed, 13 Feb 2013 19:43:41 +1000
In-Reply-To: <511B5DD0.1040103@broadcom.com>
References: <20130212203417.890993903@linuxfoundation.org>
	 <20130212203426.021116247@linuxfoundation.org>
	 <1360726523.3642.4.camel@thor.lan> <511B5DD0.1040103@broadcom.com>
Organization: Red Hat
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-02-13 at 10:33 +0100, Arend van Spriel wrote:
> On 02/13/2013 04:35 AM, Peter Hurley wrote:
> > On Tue, 2013-02-12 at 12:35 -0800, Greg Kroah-Hartman wrote:
> >> 3.7-stable review patch.  If anyone has any objections, please let me know.
> > 
> > FWIW, I never saw this on 3.7 but it happened 1st time on 3.8-rcX
> > I haven't tested this fix either.
> 
> Dito.
> 
> Gr. AvS
Yeah, I don't believe anything could trigger it in 3.7.  It doesn't hurt
anyway.

> 
> 


