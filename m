Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762330Ab3DCLue (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 07:50:34 -0400
Received: from mail-ob0-f171.google.com ([209.85.214.171]:35895 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758766Ab3DCLud convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 07:50:33 -0400
Date: Wed, 03 Apr 2013 06:50:28 -0500
From: Rob Landley <rob@landley.net>
Subject: Re: [RFC] kbuild: fix ld-option function
To: Antony Pavlov <antonynpavlov@gmail.com>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Antony Pavlov <antonynpavlov@gmail.com>
References: <1364922822-7510-1-git-send-email-antonynpavlov@gmail.com>
In-Reply-To: <1364922822-7510-1-git-send-email-antonynpavlov@gmail.com>
	(from antonynpavlov@gmail.com on Tue Apr  2 12:13:42 2013)
X-Mailer: Balsa 2.4.11
Message-Id: <1364989828.18069.14@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/02/2013 12:13:42 PM, Antony Pavlov wrote:
> The kbuild's ld-option function is broken because
> the command
>   $(CC) /dev/null -c -o "$$TMPO"
> does not create object file!

Could you glue the doc fix to this one and submit then as one patch to  
the kbuild guys, please?

Thanks,

Rob