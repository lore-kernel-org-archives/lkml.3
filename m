Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754561Ab3CZRt0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 13:49:26 -0400
Received: from ud10.udmedia.de ([194.117.254.50]:58787 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755355Ab3CZRtX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 13:49:23 -0400
Date: Tue, 26 Mar 2013 18:49:19 +0100
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Mike Keehan <mike@keehan.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Git bisect problem
Message-ID: <20130326174919.GA504@x4>
References: <20130326162228.288994ef@laptop3>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130326162228.288994ef@laptop3>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013.03.26 at 16:22 +0000, Mike Keehan wrote:
> I'm trying to find out which update causes my 5G Wifi
> connection to time out when authenticating.
> 
> Following the instructions in git help bisect, I
> git cloned the kernel, then git bisect start, and
> git bisect bad v3.9.0-rc2.
> 
> This errors with :-
>   fatal: Needed a single revision
>   Bad rev input: v3.9.0-rc2
> 
> and git bisect good v3.9.0-rc1 gives same error.
> 
> How are you supposed to specify the revision?

Try without the ".o", e.g.: git bisect bad v3.9-rc2 

-- 
Markus
