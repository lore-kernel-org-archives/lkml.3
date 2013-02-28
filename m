Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753567Ab3B1LfS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 06:35:18 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:49620 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752918Ab3B1LfQ (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:3:1>);
	Thu, 28 Feb 2013 06:35:16 -0500
Message-Id: <512F4F0102000078000C1EB8@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.1 
Date: Thu, 28 Feb 2013 11:35:13 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "=?UTF-8?Q?Roger=20Pau=20Monn=C3=A9?=" <roger.pau@citrix.com>
Cc: "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH RFC 00/12] xen-block: indirect
 descriptors
References: <1362047335-26402-1-git-send-email-roger.pau@citrix.com>
 <512F443702000078000C1DF7@nat28.tlf.novell.com>
 <512F3EA9.1070704@citrix.com>
In-Reply-To: <512F3EA9.1070704@citrix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 28.02.13 at 12:25, Roger Pau Monné<roger.pau@citrix.com> wrote:
> This is the expanded graph that also contains indirect descriptors
> without persistent grants:
> 
> http://xenbits.xen.org/people/royger/plot_indirect_nopers.png 

Thanks. Interesting - this suggests an unexpectedly high hit rate.

Jan
