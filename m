Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752367AbbAQLjK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2015 06:39:10 -0500
Received: from mail-pd0-f179.google.com ([209.85.192.179]:59240 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751471AbbAQLjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2015 06:39:08 -0500
Date: Sat, 17 Jan 2015 03:39:04 -0800
From: Jeremiah Mahler <jmmahler@gmail.com>
To: Dudley Du <dudl@cypress.com>, dmitry.torokhov@gmail.com,
        rydberg@euromail.se, bleung@google.com, dso@cypress.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v18 00/12] input: cyapa: instruction of cyapa patches
Message-ID: <20150117113904.GA2133@hudson.localdomain>
Mail-Followup-To: Jeremiah Mahler <jmmahler@gmail.com>,
	Dudley Du <dudl@cypress.com>, dmitry.torokhov@gmail.com,
	rydberg@euromail.se, bleung@google.com, dso@cypress.com,
	linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1421390055-32760-1-git-send-email-dudl@cypress.com>
 <20150117104415.GA2083@hudson.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150117104415.GA2083@hudson.localdomain>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dudley,

On Sat, Jan 17, 2015 at 02:44:15AM -0800, Jeremiah Mahler wrote:
> Dudley,
> 
> Your patch series applies without issue but unfortunately I
> could not test them because I ran in to a bug created by someone
> elses patch (not yours) [1].
> 
>   [1]: https://lkml.org/lkml/2015/1/17/24
> 
> Once that issue gets resolved I would be happy to test your patch
> series.
> 

If I go back to linux-next 20150112 I can avoid the drm/i915 bug.
Then, with this patch series applied, everything works well.
Suspend/resume work, and the touchpad operates as expected.

Tested-by: Jeremiah Mahler <jmmahler@gmail.com>

-- 
- Jeremiah Mahler
