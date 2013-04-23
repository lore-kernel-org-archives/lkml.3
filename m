Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932361Ab3DWQ14 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 12:27:56 -0400
Received: from sauhun.de ([89.238.76.85]:50731 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932325Ab3DWQ1z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 12:27:55 -0400
Date: Tue, 23 Apr 2013 18:27:51 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: EUNBONG SONG <eunb.song@samsung.com>
Cc: "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Re: Re: [PATCH]  I2C: Change the value of octeon i2c adapter
 timeout value
Message-ID: <20130423162751.GA3228@the-dreams.de>
References: <11281802.80061366444168759.JavaMail.weblogic@epml02>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <11281802.80061366444168759.JavaMail.weblogic@epml02>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

what mail client do you use? It seems to break message threading on my side :(


> > Have you been writing to EEPROMS? Their erase/write cycle might be
> > longer. But I am not forcing you to change the value, just giving some
> > suggestions.
> 
> My board has i2c mux, temp sensor, eeprom.  And I added some debugging code for measuring i2c response time as below  and 
> run i2c operation for each device. 
> The maximum respeonse time was 500usec(under 1msec). So 20 msec is enough for adapter timeout. 

Well, OK, I don't mind. We can increase it later if needed.

Applied to for-next, thanks! Please have a look later how I changed your
commit messages to see the preferred style.

