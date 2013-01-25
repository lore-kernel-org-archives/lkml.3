Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756515Ab3AYCaL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 21:30:11 -0500
Received: from intranet.asianux.com ([58.214.24.6]:24511 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755284Ab3AYCaH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 21:30:07 -0500
X-Spam-Score: -100.9
Message-ID: <5101EE2B.3080004@asianux.com>
Date: Fri, 25 Jan 2013 10:30:03 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: "Theodore Ts'o" <tytso@mit.edu>, Valdis.Kletnieks@vt.edu,
        Greg KH <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Consult] Plan: personal contributes plan for 2013
References: <50FFCA59.5070903@asianux.com> <30811.1359070263@turing-police.cc.vt.edu> <20130125021437.GA28908@thunk.org>
In-Reply-To: <20130125021437.GA28908@thunk.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2013年01月25日 10:14, Theodore Ts'o 写道:
> Just to be curious, I checked the number of commits I've done in the
> past 12 months, and it's 99, for an average of a bit over 8 patches a
> month.  (via "git log --author=tytso --since="1 year ago" --oneline |
> wc -l")
> 

  thank you very much for your information which I can according to.
  it is quite valuable for me to make my plan.


> More importantly, it's important to shoot for quality, not quantity.
> 10 patches a month which fixes whitespaces in code that you're not
> touching anyway just generates work for maintainers without materially
> improving the quality of the kernel.
> 

  really necessary to give enough limitations (this is just my plan does):

    patch contents: which sub-system, API (document), architecture, ...

    patch type: functional features or none-functional features
                for non-functional features:
                  bug fix: memory overflow, resource management ...
                  API:  comments, documents, MAINTAINERS, ...
                  others: beautify code, ...

    marked as: Reported-by or Signed-of-by, ...


-- 
Chen Gang

Asianux Corporation
