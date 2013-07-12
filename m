Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757574Ab3GLO6u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 10:58:50 -0400
Received: from kanga.kvack.org ([205.233.56.17]:52231 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757353Ab3GLO6t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 10:58:49 -0400
Date: Fri, 12 Jul 2013 10:58:46 -0400
From: Benjamin LaHaise <bcrl@kvack.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, stable@vger.kernel.org
Subject: Re: [ 00/11] 3.4.53-stable review
Message-ID: <20130712145846.GT5403@kvack.org>
References: <20130711220545.542911892@linuxfoundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130711220545.542911892@linuxfoundation.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 11, 2013 at 03:11:00PM -0700, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.4.53 release.
> There are 11 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

This seems to be missing e643692138cfa33528f054b071ba2583509bb217 -- 
"ext3: fix data=journal fast mount/umount hang" which I submitted last 
week.

		-ben
-- 
"Thought is the essence of where you are now."
